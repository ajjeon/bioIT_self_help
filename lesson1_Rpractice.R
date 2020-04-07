# R has some datasets that come with it. They can be loaded using "data" function.
# We will use a dataset called "iris"

data("iris")

# iris data set gives the measurements in centimeters 
# of the variables sepal length, sepal width, petal length and petal width, 
# for 50 flowers from each of 3 species of iris. 
# The species are Iris setosa, versicolor, and virginica.

head(iris) # to print first few lines of the data frame

class(iris$Sepal.Length)
class(iris$Species)
# in R, "factor" variables are used for categorical variables.
# Be careful between using "factor" and "character" variables. They have different properties.
# When data gets imported, the default option in R is always to treat character values (strings) as factor.
# You can switch it off by setting stringsAsFactors=FALSE

iris$Species

# Do you see "Levels: setosa versicolor virginica"? Using "factor" class
# enables us to group the categorical variables. Whereas...

as.character(iris$Species)

# By converting them to "character" class, they no longer retain the group information.
# See the differences in "numeric", "factor", and "character" classes when we apply the function "summary" to them

summary(iris$Petal.Length)
summary(iris$Species)
summary(as.character(iris$Species))


# You can extract certain data by referring to its row and column
# We use square brackets to do so, and it's in the format of [row number, column number]

iris[3,1]

# You can leave one blank to refer to the entire row or column

iris[3,] # to select the entire 3rd row

# You can refer to columns either by its index or its name (if available)

iris[,1] # 1st column of the dataframae iris
iris$Sepal.Length # Sepal.Length column of the dataframe iris
iris[,1] == iris$Sepal.Length # double equal sign tests whether all values in two vectors are the same
all(iris[,1] == iris$Sepal.Length) # function "all" tests if everything in the vector is TRUE

# explore logical tests a little more. They are useful in filtering values.

iris$Sepal.Length > 5.0 # asks which of them have "Sepal.Length" values greater than 5.0
table(iris$Sepal.Length > 5.0) # shows how many TRUE and FALSE we have. TRUE means the value is greater than 5.0. FALSE means less or equal to 5.0
iris$Sepal.Length[iris$Sepal.Length > 5.0] # We can place the logical true/false vector inside square bracket to extract values that are "TRUE"
# So this line will return the values that are greater than 5.0
(iris$Sepal.Length > 5.0) & (iris$Sepal.Length < 7.0) # We can have more than one conditions and combine them by AND (&), OR (|), etc.
iris$Sepal.Length[(iris$Sepal.Length > 5.0) & (iris$Sepal.Length < 7.0)] 
# this line now returns the values that are greater than 5.0 and less than 7.0

# Let's do some basic plotting

plot(iris$Sepal.Width, iris$Sepal.Length)
