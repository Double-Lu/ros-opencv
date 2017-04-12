/*
 * Copyright (C) 2014 EPFL
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see http://www.gnu.org/licenses/.
 */

/**
 * @file CameraThread.cpp
 * @brief Listens to the camera in a separate thread
 * @author Ayberk Özgür
 * @version 1.0
 * @date 2014-09-23
 */

#include"CameraThread.h"

//*****************************************************************************
// CameraTask implementation
//*****************************************************************************

CameraTask::CameraTask(
    BetterVideoCapture* camera, 
    QVideoFrame* videoFrame, 
    unsigned char* cvImageBuf, 
    int width, 
    int height, 
    int * brightness, 
    float * contrast, 
    bool * objectDetectionActive, 
    bool * licenseDetectionActive,
    bool * eyesDetectionActive)
{
    this->running = true;
    this->camera = camera;
    this->videoFrame = videoFrame;
    this->cvImageBuf = cvImageBuf;
    this->width = width;
    this->height = height;
    this->brightness = brightness;
    this->contrast = contrast;
    this->objectDetectionActive = objectDetectionActive;
    this->licenseDetectionActive = licenseDetectionActive;
    this->eyesDetectionActive = eyesDetectionActive;
}

CameraTask::~CameraTask()
{
    //Leave camera and videoFrame alone, they will be destroyed elsewhere
}

void CameraTask::stop()
{
    running = false;
}

void CameraTask::convertUVsp2UVp(unsigned char* __restrict srcptr, unsigned char* __restrict dstptr, int stride)
{
    for(int i=0;i<stride;i++){
        dstptr[i]           = srcptr[i*2];
        dstptr[i + stride]  = srcptr[i*2 + 1];
    }
}

void CameraTask::doWork()
{

#if defined(QT_DEBUG) && !defined(ANDROID)
    QElapsedTimer timer;
    float fps = 0.0f;
    int millisElapsed = 0;
    int millis;
    timer.start();
#endif

    if(videoFrame)
        videoFrame->map(QAbstractVideoBuffer::ReadOnly);

#ifndef ANDROID //Assuming desktop, RGB camera image and RGBA QVideoFrame
    cv::Mat screenImage;
    if(videoFrame)
        screenImage = cv::Mat(height,width,CV_8UC4,videoFrame->bits());
#endif


    cv::String face_cascade_name = "/home/tyler/OpenCV/data/lbpcascades/lbpcascade_frontalface.xml";
    cv::String eyes_cascade_name = "/home/tyler/OpenCV/data/haarcascades/haarcascade_eye_tree_eyeglasses.xml";
    cv::String body_cascade_name = "/home/tyler/OpenCV/data/haarcascades/haarcascade_fullbody.xml";
    cv::CascadeClassifier face_cascade;
    cv::CascadeClassifier eyes_cascade;
    cv::CascadeClassifier body_cascade;

    if( !face_cascade.load( face_cascade_name ) ){ printf("--(!)Error loading face cascade\n"); };
    if( !eyes_cascade.load( eyes_cascade_name ) ){ printf("--(!)Error loading eyes cascade\n");  };
    if( !body_cascade.load( body_cascade_name ) ){ printf("--(!)Error loading body_cascade \n");  };


    int count = 0;
    std::ofstream logFile;
    float contrastControl = 2.6;
    int brightnessControl = 88;
    bool savedImg = false;
    cv::Mat customMat;

    logFile.open("/home/tyler/UAV_LOG_FILE.txt");
    while(running && videoFrame != NULL && camera != NULL){
        if(!camera->grabFrame())
            continue;
        unsigned char* cameraFrame = camera->retrieveFrame();

        //Get camera image into screen frame buffer
        if(videoFrame){

#ifdef ANDROID //Assume YUV420sp camera image and YUV420p QVideoFrame

            //Copy over Y channel
            memcpy(videoFrame->bits(),cameraFrame,height*width);

            //Convert semiplanar UV to planar UV
            convertUVsp2UVp(cameraFrame + height*width, videoFrame->bits() + height*width, height/2*width/2);

#else //Assuming desktop, RGB camera image and RGBA QVideoFrame
            cv::Mat tempMat(height,width,CV_8UC3,cameraFrame);

            //cv::cvtColor(tempMat,screenImage,cv::COLOR_RGB2RGBA); //COLOR_BGR2GRAY
            //cv::cvtColor(tempMat,tempMat,cv::COLOR_BGR2GRAY);`
            cv::Mat frame_gray;
            std::vector<cv::Rect> faces;
            std::vector<cv::Rect> bodies;
            cv::cvtColor(tempMat,customMat,cv::COLOR_RGB2RGBA);
            if(*(this->objectDetectionActive)){

                cv::cvtColor( customMat, frame_gray, cv::COLOR_BGR2GRAY );
                cv::equalizeHist( frame_gray, frame_gray );

                //-- Detect faces

                face_cascade.detectMultiScale( frame_gray, faces, 1.1, 2, 0, cv::Size(80, 80) );

                for( size_t i = 0; i < faces.size(); i++ )
                {
                    cv::Mat faceROI = frame_gray( faces[i] );
                        //-- Draw the face
                    cv::Point center( faces[i].x + faces[i].width/2, faces[i].y + faces[i].height/2 );
                    cv::ellipse( customMat, center, cv::Size( faces[i].width/2, faces[i].height/2 ), 0, 0, 360, cv::Scalar( 255, 0, 0 ), 2, 8, 0 );

                    if(*(this->eyesDetectionActive)){
                        std::vector<cv::Rect> eyes;

                        //-- In each face, detect eyes
                        eyes_cascade.detectMultiScale( faceROI, eyes, 1.1, 2, 0 |cv::CASCADE_SCALE_IMAGE, cv::Size(30, 30) );
                        if( eyes.size() == 2)
                        {
                            //-- Draw the face
                            cv::Point center( faces[i].x + faces[i].width/2, faces[i].y + faces[i].height/2 );
                            // cv::ellipse( customMat, center, cv::Size( faces[i].width/2, faces[i].height/2 ), 0, 0, 360, cv::Scalar( 255, 0, 0 ), 2, 8, 0 );

                            for( size_t j = 0; j < eyes.size(); j++ )
                            { //-- Draw the eyes
                                cv::Point eye_center( faces[i].x + eyes[j].x + eyes[j].width/2, faces[i].y + eyes[j].y + eyes[j].height/2 );
                                int radius = cvRound( (eyes[j].width + eyes[j].height)*0.25 );
                                cv::circle( customMat, eye_center, radius, cv::Scalar( 255, 0, 255 ), 3, 8, 0 );
                            }
                        }
                    }
                }
            }


            if(*(this->licenseDetectionActive)){
                body_cascade.detectMultiScale( frame_gray, bodies, 1.1, 2, 0, cv::Size(80, 80) );
                for( size_t i = 0; i < bodies.size(); i++ )
                {
                    cv::Mat bodyROI = frame_gray( bodies[i] );
                    //-- Draw the face
                    cv::Point center( bodies[i].x + bodies[i].width/2, bodies[i].y + bodies[i].height/2 );
                    cv::ellipse( customMat, center, cv::Size( bodies[i].width/2, bodies[i].height*0.75 ), 0, 0, 360, cv::Scalar( 255, 0, 0 ), 2, 8, 0 );


                }
            }
            


            if(*(this->eyesDetectionActive) && !(*(this->objectDetectionActive))){

                face_cascade.detectMultiScale( frame_gray, faces, 1.1, 2, 0, cv::Size(80, 80) );

                for( size_t i = 0; i < faces.size(); i++ )
                {
                    cv::Mat faceROI = frame_gray( faces[i] );
                    std::vector<cv::Rect> eyes;

                    //-- In each face, detect eyes
                    eyes_cascade.detectMultiScale( faceROI, eyes, 1.1, 2, 0 |cv::CASCADE_SCALE_IMAGE, cv::Size(30, 30) );
                    if( eyes.size() == 2)
                    {
                        //-- Draw the face
                        cv::Point center( faces[i].x + faces[i].width/2, faces[i].y + faces[i].height/2 );
                        // cv::ellipse( customMat, center, cv::Size( faces[i].width/2, faces[i].height/2 ), 0, 0, 360, cv::Scalar( 255, 0, 0 ), 2, 8, 0 );

                        for( size_t j = 0; j < eyes.size(); j++ )
                        { //-- Draw the eyes
                            cv::Point eye_center( faces[i].x + eyes[j].x + eyes[j].width/2, faces[i].y + eyes[j].y + eyes[j].height/2 );
                            int radius = cvRound( (eyes[j].width + eyes[j].height)*0.25 );
                            cv::circle( customMat, eye_center, radius, cv::Scalar( 255, 0, 255 ), 3, 8, 0 );
                        }
                    }

                }
            }
            

            customMat.convertTo(screenImage, -1, *(this->contrast), *(this->brightness));
            /*if(count > 100){

                logFile << "Iteration " << count << "\n";   
                count = 0;
                logFile << "screenImage =" << format(screenImage, cv::Formatter::FMT_C) << ";\n";
                if(!savedImg){

                    screenImage.convertTo(customMat, -1, contrastControl, brightnessControl);
                    imwrite("/home/tyler/MY_CV_IMG.jpg", customMat);
                    savedImg = true;
                }

            }*/
 /*for( int y = 0; y < image.rows; y++ )
    { for( int x = 0; x < image.cols; x++ )
         { for( int c = 0; c < 3; c++ )
              {
      new_image.at<Vec3b>(y,x)[c] =
         saturate_cast<uchar>( alpha*( image.at<Vec3b>(y,x)[c] ) + beta );
             }
    }
    }
      */      
            count++;


#endif

        }

        //Export camera image
        if(cvImageBuf){

#ifdef ANDROID //Assume YUV420sp camera image
            memcpy(cvImageBuf,cameraFrame,height*width*3/2);
#else //Assuming desktop, RGB camera image
            memcpy(cvImageBuf,cameraFrame,height*width*3);
#endif

        }

        emit imageReady();

#if defined(QT_DEBUG) && !defined(ANDROID)
        millis = (int)timer.restart();
        millisElapsed += millis;
        fps = CAM_FPS_RATE*fps + (1.0f - CAM_FPS_RATE)*(1000.0f/millis);
        if(millisElapsed >= CAM_FPS_PRINT_PERIOD){
            qDebug("Camera is running at %f FPS",fps);
            millisElapsed = 0;
        }
#endif

    }
}

//*****************************************************************************
// CameraThread implementation
//*****************************************************************************

CameraThread::CameraThread(
    BetterVideoCapture* camera, 
    QVideoFrame* videoFrame, 
    unsigned char* cvImageBuf, 
    int width, int height, int * brightness, 
    float * contrast, 
    bool * objectDetectionActive,
    bool * licenseDetectionActive,
    bool * eyesDetectionActive)
{
    task = new CameraTask(camera,
        videoFrame,
        cvImageBuf,
        width,height, 
        brightness, 
        contrast, 
        objectDetectionActive, 
        licenseDetectionActive,
        eyesDetectionActive
    );
    task->moveToThread(&workerThread);
    connect(&workerThread, SIGNAL(started()), task, SLOT(doWork()));
    connect(task, SIGNAL(imageReady()), this, SIGNAL(imageReady()));
}

CameraThread::~CameraThread()
{
    stop();
    delete task;
}

void CameraThread::start()
{
    workerThread.start();
}

void CameraThread::stop()
{
    if(task != NULL)
        task->stop();
    workerThread.quit();
    workerThread.wait();
}

