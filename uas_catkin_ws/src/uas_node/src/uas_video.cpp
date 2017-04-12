#include <ros/ros.h>
 #include <image_transport/image_transport.h>
 #include <cv_bridge/cv_bridge.h>
 #include <sensor_msgs/image_encodings.h>
 #include <opencv2/imgproc/imgproc.hpp>
 #include <opencv2/highgui/highgui.hpp>
#include <boost/asio.hpp>
#include <iostream>
using namespace boost::asio;
using namespace std;

static const std::string OPENCV_WINDOW = "Image window";

class ImageConverter
{
    ros::NodeHandle nh_;
    image_transport::ImageTransport it_;
    image_transport::Subscriber image_sub_;
    image_transport::Publisher image_pub_;
    boost::asio::io_service io_service;
    boost::asio::ip::udp::endpoint remote_endpoint;
    boost::asio::ip::udp::socket * socket;
    boost::system::error_code err;
    bool sizeIsSet;
    unsigned int sizeOfCvElement;

public:
 ImageConverter()
 : it_(nh_)
 {
  sizeIsSet = false;
  string userInput;
  ROS_WARN("Hello user. i am in ImageConverter() about to initialize the socket ... ok?");
  cin >> userInput;

   socket = new ip::udp::socket(io_service);
   ROS_WARN("Initialized the socket, about to open...ok?");
  cin >> userInput;
  

  socket->open(ip::udp::v4());
   ROS_WARN("opened the socket, about to initialize remote_endpoint...ok?");
  cin >> userInput;

  remote_endpoint = ip::udp::endpoint(ip::address::from_string("127.0.0.1"), 8585);


   ROS_WARN("initialized the remote_endpoint, about to subscribe to camera topic ok?...");
  cin >> userInput;

     // Subscrive to input video feed and publish output video feed
   image_sub_ = it_.subscribe("/front_cam/camera/image", 1, 
     &ImageConverter::imageCb, this);
   image_pub_ = it_.advertise("/image_converter/output_video", 1);

   cv::namedWindow(OPENCV_WINDOW);
    ROS_WARN("Leaving ImageConverter constructor...\n");
 }
 
 ~ImageConverter()
 {
  socket->close();
  delete socket;
   cv::destroyWindow(OPENCV_WINDOW);
 }
 
 void imageCb(const sensor_msgs::ImageConstPtr& msg)
 {
   cv_bridge::CvImagePtr cv_ptr;
   try
   {
     cv_ptr = cv_bridge::toCvCopy(msg, sensor_msgs::image_encodings::BGR8);
   }
   catch (cv_bridge::Exception& e)
   {
     ROS_ERROR("cv_bridge exception!");
     return;
   }

     // Draw an example circle on the video stream
   if (cv_ptr->image.rows > 60 && cv_ptr->image.cols > 60)
     cv::circle(cv_ptr->image, cv::Point(50, 50), 10, CV_RGB(255,0,0));

     // Update GUI Window
   cv::imshow(OPENCV_WINDOW, cv_ptr->image);
   cv::waitKey(3);

     // Output modified video stream
   unsigned char * imageData = cv_ptr->image.data;
   if(!sizeIsSet){
    sizeOfCvElement = sizeof(imageData[0]);
    sizeIsSet = true;
   }
    socket->send_to(buffer(imageData, sizeof(imageData)/sizeOfCvElement), remote_endpoint, 0, err);
   image_pub_.publish(cv_ptr->toImageMsg());
 }
};

int main(int argc, char** argv)
{

  ros::init(argc, argv, "image_converter");
  ImageConverter ic;
  ros::spin();
  return 0;
}