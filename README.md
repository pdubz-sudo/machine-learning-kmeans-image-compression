# machine-learning-kmeans-image-compression
Using unsupervised learning to cluster colors in a picture and compressing the image with those cluster

Programming Language: R

The Kmeans algorith is an unsuperviesed learning algorithm that groups similar data samples together. These groups
can be thought of as clusters and at the center of the cluster is a centroid. The process to determine the cluster centroids 
is an iterative process that starts with random initial centroids and assigns training samples to their closest 
centroids and then recomputes the centroids. This is a powerful algorith that has many uses such as segmenting purchase history,
customers, behavior, motion sensor activity types, etc. 

This repository focuses on using Kmeans algorith to compress an image by clustering colors together into a limited amount of 
colors and reconstructing the image with those colors. The process is completely unsupervised as we do not indicate any labels 
for the colors: only indicate how many clusters we want. To do this we need to know how images are structured. All images
contain 3 colors (red, blue, and green) and each color has a value ranging from 0-255 in a 24-bit color representation.
The original image has thousands of colors and we will use Kmeans to group similar colors into only 10 colors and then 
place those 10 colors back into the image according to their cluster index assignment. This would compress the image 
because the image only needs to store red, green, and blue values for 10 colors instead of thousands and for each 
pixel in the image we only have to store the index of the color cluster.

    The image used is a picture of a beach which I took in Lagos, Portual. The image has dimensions 480 x 223.
    The size of the original image is 480 x 223 x 24 = 2,568,960 bits

Since we have only 10 colors now at 24 bits we saved a lot of space in comparison to the thousands of different colors.
In addition, each pixel only needs now 4 bits per location.
    
    The size of the recompression using our clustered label assignments 24 x 10 + 480 x 223 x 4 = 428,400 bit.

The recompression is 6 times smaller than the original image.

## Note

There are 2 scripts in this repository. One manipulates the data using dataframes and the other script manipulates
the color data as arrays and vectors. The end result is the same for both of them.

I included a pdf file that shows the original image and all the cluster reconstructions going from 1-10 cluster. 
It goes from left to right all the way down to the final reconstructed image of 10 colors at the bottom.
