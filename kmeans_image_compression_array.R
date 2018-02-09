# install.packages("imager")
# install.packages("dplyr")
library(imager)
library(dplyr)


# Load pic
beach <- load.image("beach.jpg")

# See dimensions
dim(beach)

# Plot
plot(beach)

# make matrix of colors (red, blue, green)
color_matrix <- matrix(beach, nrow = (dim(beach)[1] * dim(beach)[2]), ncol = dim(beach)[4])

# perfom K-means
k <- 10
max_iter <- 50
K_findings = kmeans(color_matrix, centers = k, iter.max = max_iter, nstart = 30, algorith="MacQueen")

# Assign each pixel to closest centroid
cluster_group <- cbind(color_matrix, K_findings$cluster)

# Make matrix of cluster groups and their color values
color_centroid_centers <- cbind(1:nrow(K_findings$centers),
                            K_findings$centers[ ,1],
                            K_findings$centers[ ,2],
                            K_findings$centers[ ,3])

# Match the pixel location with the assigned color cluster for compression. 
compressed_image <- matrix(cluster_group[ ,4],
                           nrow = dim(beach)[1], 
                           ncol = dim(beach)[2]) # %>% as.cimg %>% plot

# Reconstruct pic with centroid color values by making image array with red, blue, and green. 
# Use matrix multiplication. First need to convert color group vector into binary matrix.
cluster_binary_matrix <- matrix(0, nrow = nrow(cluster_group), ncol = max(K_findings$cluster))
cluster_binary_matrix[col(cluster_binary_matrix) == cluster_group[ ,4]] <- 1

new_colors_matrix <- cluster_binary_matrix %*% K_findings$centers

reconstructed_pic <- array(0, dim = dim(beach))
reconstructed_pic[ , , , 1] <- matrix(new_colors_matrix[ ,1])
reconstructed_pic[ , , , 2] <- matrix(new_colors_matrix[ ,2])
reconstructed_pic[ , , , 3] <- matrix(new_colors_matrix[ ,3])

reconstructed_pic %>% as.cimg %>% plot
