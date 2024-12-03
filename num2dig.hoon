:: Generator that takes a vase of @ub, @ud, or @ux as an 
:: argument and returns a tape of the ASCII values 
:: corresponding to the value represented by the vase. This 
:: is an exercise in Hoon School 6., Example: Number to Digits.

:: Gate takes input of vase which is a pair of type and noun.
|=  input=[type *]

:: Pin a value 'n' which is the value in the tail of the vase,
:: converted from noun to atom so that we can do math on it.
=/  n  !<(@ input)

:: Pin a value 'values' in which we will build the tape and 
:: eventually output as the result. 
=/  values  *(list @t)

:: Three wutcols will determine the math we peform on 'n' 
:: depending on if type was @ub, @ud, or @ux.
?:  =(+.-:input [%ub ~])

:: Branch if type was @ub
  |-  ^-  (list @t)
  ?:  (lte n 0)  values
  %=  $
    n       (div n 2)
    values  (@t (add 48 (mod n 2)))^values
  ==

?:  =(+.-:input [%ud ~])

:: Branch if type was @ud
  |-  ^-  (list @t)
  ?:  (lte n 0)  values
  %=  $
    n       (div n 10)
    values  (@t (add 48 (mod n 10)))^values
  ==

?:  =(+.-:input [%ux ~])

:: Branch if type was @ux 
  |-  ^-  (list @t)
  ?:  (lte n 0)  values
  %=  $
    n       (div n 16)
    values  
      ?:  (lte (mod n 16) 9)

      :: Branch if digit was a number 0 thru 9
        (@t (add 48 (mod n 16)))^values

      :: Branch if digit was a letter a thru f
      (@t (add 87 (mod n 16)))^values
  ==

:: Return message and crash if argument wasn't 
:: a @ub, @ud, or @ux
~&  'type was not @ub, @ud, or @ux, try again'
!!