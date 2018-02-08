# install.packages("imager")
# install.packages("dplyr")
# install.packages("data.table")
library(imager)
library(dplyr)
library(data.table)

# Load pic
beach <- load.image("beach.jpg")

# See dimensions
dim(beach)

# Plot
plot(beach)

# Make dataframe
df_beach <- as.data.frame(beach)

# Seperate colors red, blue, and green
red <- filter(df_beach, cc == 1) %>% select(value) %>% rename(red = value)
blue <- filter(df_beach, cc == 2) %>% select(value) %>% rename(blue = value)
green <- filter(df_beach, cc == 3) %>% select(value) %>% rename(green = value)

# make color dataframe which will be clustered with kmeans
df_original_colors = data.frame(red, blue, green)

# perfom K-means
K_findings = kmeans(df_original_colors, centers = 10, iter.max = 100, nstart = 50, algorith="MacQueen")

# Assign pixel to closest color cluster##############################################
df_original_colors[,"cluster"] <- K_findings$cluster
# or color_df$cluster <- K_findings$cluster

# Make dataframe of all clusters with their kmeans center values
df_kmeans_clusters = data.frame(cluster = 1:nrow(K_findings$centers), 
                            red_cluster = K_findings$centers[ ,"red"],
                            blue_cluster = K_findings$centers[ ,"blue"],
                            green_cluster = K_findings$centers[ , "green"])

# Match the pixel location with the assigned color cluster for compression. 
#Using data.table is a very efficient way to do this; although and index must be 
# made first because the order is not retained. This can also be done with the join 
# function with the argument type = "inner" which also retains the order; however, this 
# function is slower when dealing with bigger datasets compared to using data.table
df_original_colors[ , "index"] <- seq.int(nrow(df_original_colors))  #creates index ###################
dt_original <- data.table(df_original_colors, key = "cluster")
dt_clusters <- data.table(df_kmeans_clusters, key = "cluster")
df_all_colors <- dt_original[dt_clusters] %>% data.frame
df_all_colors <- df_all_colors[order(df_all_colors[, "index"]),] #ordering the rows in the index column
compressed_image <- matrix(df_all_colors$cluster, nrow = 480, ncol = 223) #%>% as.cimg %>% plot

# Rebuild dataframe that will be converted to cimg for imager library for plotting. 
# dataframe needs columns x,y,cc,value
df_base <- select(df_beach, x, y, cc)
df_color_cluster <- data.frame(value = c(df_all_colors$red_cluster, 
                                         df_all_colors$blue_cluster, 
                                         df_all_colors$green_cluster))
compressed_beach_pic <- data.frame(df_base, df_color_cluster) %>% as.cimg(dim=c(480, 223, 1, 3))

# Plot
plot(compressed_beach_pic)