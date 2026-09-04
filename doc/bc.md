# Calculating with bc
 
 Run bc and calculate away, but it is very important to remember these things:
 Issue "scale=5" to let bc use 5 digits after the decimal point. Otherwise it will show you ridiculous things like 10/3=3 etc. By default, scale is set to 0 so floats are treated as int.
 Use "last" to refer to "Ans", which is the last number is buffer.
 You can declare variable and do their calculations like this:
  a=50
  b=30
  c=a+b
  c
  80
 etc.
