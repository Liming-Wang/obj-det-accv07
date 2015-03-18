# obj-det-accv07
## Introduction
This is source code for the ACCV 2007 paper, "Object Detection Combining Recognition and Segmentation"

##How to run the code
###1. Obtain the source code
You can obtain source code via subversion or directly go to Downloads page and download the zip file.

Let's denote the root folder of our source code as $SOURCE_CODE$.

###2. Download image data and pb edge detector
Our test images can be download from here: http://www.cis.upenn.edu/~jshi/ped_html/

One of our edge detection relies on pb edge detector. You can download it from our Downloads page segbench.tar.gz or from here: http://www.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/segbench/

Unzip image files to $SOURCE_CODE$/data/images/.

Unzip segbench.tar.gz to $SOURCE_CODE$/.

###3. Add project source folder to Matlab searching path list
The 'startup.m' script is meant to add whole source directories (including sub-directories) to Matlab path list.

On Linux, if you start Matlab after you change working directory to $SOURCE_CODE$, the 'startup.m' script will be automatically invoked. Otherwise, run 'startup.m' when current directory points to $SOURCE_CODE$ in Matlab.

On Windows, 'startup.m' needs to be manually invoked.

###4. Build mex files
Go to $SOURCE_CODE$/mex, and run the following script line to generate all native files.

>mex_compile


###5. Run demos
>demo_train.m

>demo_one_image.m

>demo_multi_image.m



