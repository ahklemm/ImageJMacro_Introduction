// "simple" example
c = add( 10, 20 );
print( c );

// "typically confusing" example 
f = 10;
g = 20;
c = add( f, g);
print(c)

// function NAME( ARG0, ARG1, ...)
function add( a, b )
{
	return a + b;
}


salary = 10;
incrementSalary( 10 );
print( "new salary = " + salary );

// in IJ macro functions have limited access to global variables
function incrementSalary( raise )
{
	print( "old salary = " + salary );
	salary = salary + raise;
}

// take home message: don't use global variables inside functions

// better way how to solve this:
salary = 10;
salary = incrementSalaryImproved( salary, 10 );
print( "new salary = " + salary );

// functions have limited access to global variables
function incrementSalaryImproved( salary, raise )
{
	print( "old salary = " + salary );
	return salary + raise;
}

