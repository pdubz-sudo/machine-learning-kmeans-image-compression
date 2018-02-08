# install.packages("imager")
# install.packages("dplyr")
# install.packages("data.table")
library(imager)
library(dplyr)
# library(data.table)

# Load pic
beach <- load.image("beach.jpg")

# See dimensions
dim(beach)

# Plot
plot(beach)

# Pull vectors for red, blue, and green
beach_vector <- as.vector(beach)
red <- beach[1:(dim(beach)[1] * dim(beach)[2])]
blue <- beach[((dim(beach)[1] * dim(beach)[2]) + 1): (2 * ((dim(beach)[1] * dim(beach)[2])))]
green <- beach[((2 * ((dim(beach)[1] * dim(beach)[2]))) + 1): (3 * ((dim(beach)[1] * dim(beach)[2])))]

# make dataframe of the colors for kmeans
df_color <- data.frame(red, blue, green)

# perfom K-means
k <- 10
max_iter <- 50
K_findings = kmeans(df_color, centers = k, iter.max = max_iter, nstart = 30, algorith="MacQueen")

# Assign pixel to closest color cluster
df_color[,"cluster"] <- K_findings$cluster
# or df_color$cluster <- K_findings$cluster

# Make dataframe of all clusters with their kmeans center values
df_kmeans_clusters = data.frame(cluster = 1:nrow(K_findings$centers), 
                                red_cluster = K_findings$centers[ ,"red"],
                                blue_cluster = K_findings$centers[ ,"blue"],
                                green_cluster = K_findings$centers[ , "green"])

# Match the pixel location with the assigned color cluster for compression. 
# Using data.table is a very efficient way to do this; although an index must be 
# made first because the order is not retained. This can also be done with the join 
# function with the argument type = "inner" which also retains the order; however, this 
# function is slower when dealing with bigger datasets compared to using data.table.
# This script uses the join function; to see the an implementation with the data.table 
# function used look at the other R script in this repository
df_all_colors <- join(df_color, df_kmeans_clusters, type = "inner")
compressed_image <- matrix(df_all_colors$cluster, 
                           nrow = dim(beach)[1], 
                           ncol = dim(beach)[2]) # %>% as.cimg %>% plot

# Reconstruct the pic using only kmeans color clusters
reconstructed_pic <- array(0, dim = dim(beach))
reconstructed_pic[ , , , 1] <- matrix(df_all_colors$red_cluster)
reconstructed_pic[ , , , 2] <- matrix(df_all_colors$blue_cluster)
reconstructed_pic[ , , , 3] <- matrix(df_all_colors$green_cluster)

reconstructed_pic %>% as.cimg %>% plot