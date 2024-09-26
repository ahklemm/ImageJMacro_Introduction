// define the function
function beEnthusiatic(input) {
	for (i = 0; i < 10; i++) {
		print(input + " is great!");
	}
 
}


//calling the function
subject = "Coding";
beEnthusiatic(subject);

// example with two input parameters
// function NAME( ARG0, ARG1, ...)
function add( a, b )
{
	return a + b;
}

// "typically confusing"  
f = 10;
g = 20;
c = add( f, g);
print(c)


//variables defined inside the function are not available outside of the function
print('Input:', input); //gives an error