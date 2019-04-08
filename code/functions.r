# new script for creating functions

# easy conversion Far to Kelvin
# within each function you have to identify all of your arguments. The body tells it what 
# to do, you put this in {}
# argument is the required input, defined here as "temp"
# the "return" is optional in R, it will auto return the last object, but it's a good habit
# you can pipe within a function

# came back later to add defensive
far_to_kel <- function(temp){
  if(!is.numeric(temp)){
    stop("value must be numeric")
  }
  
  kelvin <- ((temp-32)*(5/9))+273.15
  return(kelvin)
}

far_to_kel(NA)
far_to_kel(32)

# my practice - Kelvin to Celcius
kel_to_cel <- function(temp){
  celcius <- (temp-273.15)
  return(celcius)
}

kel_to_cel(0)


# Write a function converting Far to Celcius by nesting the statements above
far_to_cel <- function(temp){
  kelvin <- ((temp-32)*(5/9))+273.15
  celcius <- (kelvin-273.15)
  return(celcius)
}

far_to_cel(0)
far_to_cel(32)

# Another way to do this
far_to_cel2 <- function(far){
  cel <-  kel_to_cel(far_to_kel(far))
  return(cel)
}
far_to_cel2(32)
# Another way
far_to_cel3 <-  function(temp){
  kel <- far_to_kel(temp)
  cel <- kel_to_cel(kel)
  return(cel)
}
far_to_cel3(32)

# Defensive programming is set to allow/not allow things, ie a function that needs an 
# integer, prohibiting string
# commit before changing the function
# added defensive programming to the original far_To_kel
far_to_kel2 <- function(temp){
  stopifnot(is.numeric(temp))
  kelvin <- ((temp-32)*(5/9))+273.15
  return(kelvin)
}
far_to_kel2(NA)

# Create defensive stop for far_to_cel
far_to_cel3.1 <-  function(temp){
  stopifnot(is.numeric(temp))
  kel <- far_to_kel(temp)
  cel <- kel_to_cel(kel)
  return(cel)
}
far_to_cel3.1(NA)
far_to_cel3.2 <-  function(temp){
  if (!is.numeric(temp)) {
    stop("not numeric")
  }
  kel <- far_to_kel(temp)
  cel <- kel_to_cel(kel)
  return(cel)
}
far_to_cel3.2(NA)
# commit after changing the functions. 