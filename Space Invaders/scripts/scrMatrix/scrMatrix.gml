




//creates an empty matrix to initialize all the static functions of the constructor and ensure they have been created before being needed
var _blank = new Matrix();
delete _blank;



//Note: the functions in this constructor were mostly taken from The Coding Train's neural network matrix constructor written in JavaScript
//https://github.com/CodingTrain/Toy-Neural-Network-JS/blob/master/lib/matrix.js#L1
function Matrix( _rows = 1, _columns = 1 ) constructor {
	rows = _rows;
	cols = _columns;
	
	data = array_create(rows, undefined );
	for( var i = 0; i < rows; i++ ) {
		data[i] = array_create(cols, 0);
	}
	
	///@function				get( _row, _column)
	///@discription				returns the element at row _row, column _col
	///@return{real}			the element
	static get = function( _row, _column ) {
		return data[_row][_column];
	}
	
	///@function				set( _row, _column)
	///@discription				sets the element at row _row, column _col
	static set = function( _row, _column, _value ) {
		data[_row][_column] = _value;
	}
	
	
	///@function				duplicate()
	///@discription				returns a new matrix that is a copy of this one
	///@return{struct}			a new matrix
	static duplicate = function() {
		var _m = new Matrix( rows, cols );
		
		//copy the current matrix's values
		for( var i = 0; i < rows; i++ ) {
			array_copy( _m.data[i], 0, data[i], 0, cols );
		}
		
		return _m;
	}
	
	///@function				copy(_matrix)
	///@discription				sets this matrix to a copy of the inputted matrix
	///@param{struct}			the matrix to copy
	static copy = function( _matrix ) {
		rows = _matrix.rows;
		cols = _matrix.cols;
		data = array_create(_matrix.rows, 0);
		//copy the current matrix's values
		for( var i = 0; i < _matrix.rows; i++ ) {
			data[i] = array_create(_matrix.cols, 0);
			array_copy( data[i], 0, _matrix.data[i], 0, _matrix.cols );
		}
	}
	
	///@function				isRectangular( _array )
	///@discription				returns t/f depending on whether the 2d array is rectangular (all the arrays in the 2nd demension are the same length)
	///@return{bool}			whether the array is rectangular
	static isRectangular = function( _array ) {
		var _length = array_length(_array[0]);
		for( var i = 1; i < array_length(_array); i++ ) {
			if array_length(_array[i]) != _length {
				return false;
			}
		}
		return true;
	}
	
	///@function				fromArray(_array)
	///@discription				returns a new matrix with the data from the array
	///@param{array}			the array to make a matrix from
	///@return{struct}			a new matrix
	static fromArray = function( _array ) {
		
		//checks whether it is a 2d array, and wheather the array is rectangular
		if is_array(_array[0]) {
			if self.isRectangular(_array) {
				var _m = new Matrix(array_length(_array), array_length(_array[0]));
				_m.data = array_create(array_length(_array), 0);
				
				//copy the current matrix's values
				for( var i = 0; i < array_length(_array); i++ ) {
					_m.data[i] = array_create(array_length(_array[0]), 0);
					array_copy( _m.data[i], 0, _array[i], 0, array_length(_array[0]) );
				} 
			} else {
				show_error("The array is not rectangular", true);
			}
		} else {
			
			//I do this to avoid having to use an instance variable, bc the inputted method needs to have this data
			var _tempArgs = {
				
				array : _array
			}
		
			var _func = function(_element, _row, _col, _data) {
				return _data.array[_row];
			}
			
			var _m = new Matrix(array_length(_array), 1);
			_m.map(_func, _tempArgs);
			delete _tempArgs;
		}
		return _m;
		
	}
	
	///@function				toArray()
	///@discription				returns an array with the data of this matrix
	///@return{array}			the array
	static toArray = function() {
		var _array = array_create(rows*cols, 0);
		for( var i = 0; i < rows; i++) {
			for (var j = 0; j < cols; j++ ) {
				_array[i*cols+j] = data[i][j];
			}
		}
		return _array;
	}
	
	///@function				randomizeVals()
	///@discription				randomizes all the elements of this matrix, setting them between -1 and 1
	static randomizeVals = function() {
		
		var _random = function() {
			return random(1) * 2 - 1;
		}
		
		return self.map(_random);
		
	}
	
	///@function				add()
	///@discription				adds a matrix or scalar to this matrix
	///@param{struct/real}		the matrix or scalar to add
	static add = function( _n ) {
		if is_instanceof( _n, Matrix) {
			
			
			
			if self.rows != _n.rows || self.cols != _n.cols {
				show_error("Columns and Rows of matrix A must match columns and rows of matrix B to add", true );
				return;
			}
		
			var _tempArgs = {
				data : _n.data
			}
			var _matrixAdd = function(_element, _row, _col, _data ) {
				return _element + _data.data[_row][_col];
			}
			self.map(_matrixAdd, _tempArgs);
		} else {
			var _tempArgs = {
				num : _n
			}
			var _scalarAdd = function(_element, _row, _col, _data) {
				return _element + _data.num;
			}
			self.map(_scalarAdd, _tempArgs);
		}
	}
	
	///@function				subtract()
	///@discription				subtracts a matrix or scalar from this matrix
	///@param{struct/real}		the matrix or scalar to subtract
	static subtract = function( _n ) {
		if is_instanceof( _n, Matrix) {
			
			if self.rows != _n.rows || self.cols != _n.cols {
				show_error("Columns and Rows of matrix A must match columns and rows of matrix B to subtract", true );
				return;
			}
		
			var _tempArgs = {
				data : _n.data
			}
			var _matrixSub = function(_element, _row, _col, _data ) {
				return _element - _data.data[_row][_col];
			}
			self.map(_matrixSub, _tempArgs);
		} else {
			var _tempArgs = {
				num : _n
			}
			var _scalarSubtract = function(_element, _row, _col, _data) {
				return _element - _data.num;
			}
			self.map(_scalarSubtract, _tempArgs);
		}
	}
	
	///@function				multiply(_nDot)
	///@discription				multiplies this matrix by a matrix (dot product)
	///@param{struct}			the matrix to multiply by
	static multiplyDot = function( _n ) {
		
		//Matrix product
		if self.cols != _n.rows {
			show_error("Columns of matrix A must match rows of matrix B to multiply", true );
			return;
		}
		var _self = self;
		var _tempArgs = {
			a : _self,
			b : _n
		}
		var _matrixMult = function(_element, _row, _col, _data ) {
			//dot product of values in col
			var _sum = 0;
			for(var k = 0; k < _data.a.cols; k++) {
				_sum += _data.a.data[_row][k] * _data.b.data[k][_col];
			}
			return _sum;
		}
		
		//resize the matrix
			
		var _m = new Matrix( _self.rows, _n.cols);
		_m.map(_matrixMult, _tempArgs);
		self.copy(_m);
	}
	
	///@function				multiply()
	///@discription				multiplies this matrix by a scalar or matrix (hadamard product)
	///@param{struct/real}		the matrix or scalar to multiply
	static multiply = function( _n ) {
		if( is_instanceof( _n, Matrix )) {
			if rows != _n.rows || cols != _n.cols {
				show_error("Columns and rows of A and B must match to take the hadamard product", true);
				return;
			}
			
			//hadamard product
			var _tempArgs = {
				data : _n.data
			}
			var _matrixMult = function(_element, _row, _col, _data ) {
				return _element * _data.data[_row][_col];
			}
			self.map(_matrixMult, _tempArgs);
		} else {
			var _tempArgs = {
				num : _n
			}
			var _scalarMult = function(_element, _row, _col, _data) {
				return _element * _data.num;
			}
			self.map(_scalarMult, _tempArgs);
		}
	}
	
	///@function				transpose()
	///@discription				returns a transposed ("rotated") version of the matrix
	///@param{struct}			the matrix to transpose
	///@return{struct}			the transposed version of the matrix
	static transpose = function( _matrix ) {
		var _tempArgs = {
			data : _matrix.data
		}
		var _transpose = function(_element, _row, _col, _data ) {
			return _data.data[_col][_row];
		}
		var _m = new Matrix(_matrix.cols, _matrix.rows)
		_m.map(_transpose, _tempArgs);
		delete _tempArgs;
		return _m;
	}
	
	///@function				map()
	///@discription				runs a method on every element of the matrix
	///@param{method}			the method to run on each element (_element, _row, _col, _data)
	///@param{struct}			a stuct containing any data needed by the function (passed in through _data)
	static map = function( _func, _dataStruct ) {
		
		//apply a function to every element of the matrix
		for( var i = 0; i < rows; i++) {
			for( var j = 0; j < cols; j++ ) {
				var _val = data[i][j];
				data[i][j] = _func(_val, i, j, _dataStruct);
			}
		}
	}
	
	//customizes what is shown when the struct is printed to console
	static toString = function() {
		var _string = "";
		for(var i = 0; i < rows; i++ ) {
			_string += "\n" + string(data[i]);
		}
        return "Matrix: " + string(rows) + " rows, " + string(cols) + " columns" + _string + "\n";
    }
}
