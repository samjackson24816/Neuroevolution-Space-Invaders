//Updated: Space Invaders AI Neuroevolution v1.0




function ActivationFunction(_func, _dfunc) constructor {
	func = _func;
	dfunc = _dfunc;
}

global.sigmoid = new ActivationFunction(function(_x) {
			return 1/(1+exp(-_x));
		},
		
		function(_y) {
			return _y * ( 1 - _y);
		}
	);
	




function NeuralNetwork( _layerSizesArray = [10, 10, 10] ) constructor {
	
	//other variables
	layerSizes = _layerSizesArray;
	layerNum = array_length(layerSizes);
	static nnId = 0;
	myId = nnId;
	parentId = 0;
	nnId++;
	
	prob = 0;
	
	//initialize weights
	weights = array_create(layerNum, undefined);
	for(var i = 1; i < layerNum; i++ ) {
		weights[i] = new Matrix(_layerSizesArray[i], _layerSizesArray[i-1]);
		weights[i].randomizeVals();
	}
	
	//initialize biases
	biases = array_create(layerNum, undefined);
	for(var i = 1; i < layerNum; i++ ) {
		biases[i] = new Matrix(_layerSizesArray[i], 1 );
	}
	
	
	
	setActivationFunction(global.sigmoid);
	setLearningRate();
	setFitness();
	
	/// @function					setActivationFunction()
	/// @description				sets the function applied to the weighted sum of each past layer during forwardprop.  Function must be a global ActivationFunction struct, containing a function and its derivative
	static setActivationFunction = function( _func) {
		activationFunction = _func;
	}
	
	/// @function					setLearningRate()
	/// @description				sets the negative gradient multiplier used in backpropigation for the neural network
	static setLearningRate = function( _learningRate = 0.1 ) {
		learningRate = _learningRate;
	}
		
	/// @function					setFitness()
	/// @description				sets the fitness of the neural network (for neuroevolution)
	static setFitness = function( _fitness = 0 ) {
		fitness = _fitness;
	}
	
	/// @function					getFitness()
	/// @description				gets the fitness of the neural network (for neuroevolution)
	/// @return {real}				the neural network's fitness
	static getFitness = function() {
		return fitness;
	}
	
	/// @function					fowardprop( _input )
	/// @description				feeds a single input array through the neural network.  Sums and actvations are still left as 3d arrays, with only one entry of values (so as not to cause errors when used with forwardprop_batch)
	/// @param {array/struct}		 _input	the input array or matrix to feed forward
	/// @return {struct}			 the resulting output matrix
	static forwardprop = function( _input ) {
		//transform arrays into functions if needed
		if !is_instanceof(_input, Matrix) {
			_input = Matrix.fromArray(_input);
		}
		var _activations = array_create(layerNum, undefined);
		_activations[0] = _input;
		for(var i = 1; i < layerNum; i++ ) {
			_activations[i] = weights[i].duplicate();
			//show_debug_message(_activations[i]);
			_activations[i].multiplyDot(_activations[i-1]);
			//show_debug_message(_activations[i]);
			_activations[i].add(biases[i]);
			//show_debug_message(_activations[i]);
			_activations[i].map(activationFunction.func);
			//show_debug_message(_activations[i]);
		}
		return array_last(_activations);
	}
	
	/// @function                train(_inputs, _targets)
	/// @description             trains the neural network using a single dataset
	/// @param {array}		     _inputs	a single input array
	/// @param {array}			 _targets	a single array of what the output should be using _inputs as inputs
	static train = function(_inputs, _targets) {
		//transform arrays into matrices if needed
		if !is_instanceof(_inputs, Matrix) {
			_inputs = Matrix.fromArray(_inputs);
		}
		if !is_instanceof(_targets, Matrix) {
			_targets = Matrix.fromArray(_targets);
		}
		
		//get current output
		var _activations = array_create(layerNum, undefined);
		_activations[0] = _inputs;
		for(var i = 1; i < layerNum; i++ ) {
			_activations[i] = weights[i].duplicate();
			//show_debug_message(_activations[i]);
			_activations[i].multiplyDot(_activations[i-1]);
			//show_debug_message(_activations[i]);
			_activations[i].add(biases[i]);
			//show_debug_message(_activations[i]);
			_activations[i].map(activationFunction.func);
			//show_debug_message(_activations[i]);
		}
		var _outputs = array_last(_activations);
		
		
		//convert target to matrix
	
		
		//calculate error
		//ERROR = TARGETS - OUTPUTS
		var _errors = _targets.duplicate();
		_errors.subtract(_outputs);
		
		var _gradients = _outputs.duplicate();
		_gradients.map(activationFunction.dfunc);
		//show_debug_message("gradients" + string(_gradients));
		_gradients.multiply(_errors);
		_gradients.multiply(learningRate);
		
		
		for( var i = layerNum-1; i > 0; i--) {
			
			//calculate deltas
			var _inputsT = Matrix.transpose(_activations[i-1])
			var _weightDeltas = _gradients.duplicate();
			_weightDeltas.multiplyDot(_inputsT);
		
			//adjust the weights by the deltas
			
			weights[i].add(_weightDeltas);
			//adjust the bias by its deltas (which is just the gradients)
			biases[i].add(_gradients);
		
			//calculate hidden layer errors
			var _weightsT = Matrix.transpose(weights[i]);
			var _oldErrors = _errors;
			_errors = _weightsT.duplicate();
			_errors.multiplyDot(_oldErrors);
			
			//calculate hidden gradient
			_gradients = _activations[i-1].duplicate();
			_gradients.map(activationFunction.dfunc);
			_gradients.multiply(_errors);
			_gradients.multiply(learningRate);
		}
	}
	
	/// @function                getOutputLayerSize()
	/// @description             gets the length of the last (output) layer of the neural network
	/// @return {int}			 the length of the output layer
	static getOutputLayerSize = function() {
		return array_last(layerSizes);
	}
	
	/// @function                trainSgd( _inputs, _correctOutputs, _batchSize, _repetitionsPerBatch, _learningRate )
	/// @description			 trains network using stochastic gradient descent, randomly sorting the given data into a particular size and running backpropigation on each batch.  It is good for large sets of data. 
	/// @param {array}		     _inputs			an array of all the input arrays
	/// @param {array}			 _correctOutputs	an array of all the correct output arrays
	/// @param {int}			 _batchSize		the size of each batch that the data will be split into
	/// @param {int}			 _repetionsPerBatch	the amount of times to run backpropigation on each batch (epochs)
	/// @param {real}			 _learningRate	the factor by which the neural network is adjusted during each round of backpropigation (0-1)
	static trainSgd = function( _inputs, _correctOutputs, _batchSize, _repetitionsPerBatch, _learningRate ) {
		
		//translate layman's terms to smart people terms ;)
		var _epochs = _repetitionsPerBatch;
		
		self.setLearningRate(_learningRate);
		
		if array_length(_inputs) != array_length(_correctOutputs) {
			show_error("The inputs and correctOutputs are not the same length.  They are not alligned correctly", true);
			return;
		} else if array_length(_inputs) < 1 || array_length(_correctOutputs) < 1 {
			show_error("There is no data to train from", true);
			return;
		} else {
	
			show_debug_message("SGD commencing\n");
			
			//package the data into structs in an array so it can be randomized
			var _dataPack = array_create( array_length(_inputs), [] );
		
			for( var d = 0; d < array_length(_inputs); d++ ) {
				_dataPack[d] = { input : _inputs[d], output : _correctOutputs[d]};
			}		

			//shuffle the data now that it is packaged with its correct outputs
			var _dataPackRand = array_shuffle(_dataPack);

			//unpack the inputs and the correct outputs into two seperate arrays
			var _randInputs = array_create(array_length(_dataPackRand), 0);
			var _randCorrectOutputs = array_create(array_length(_dataPackRand), 0);

			for( var d = 0; d < array_length(_dataPackRand); d++ ) {
				_randInputs[d] = _dataPackRand[d].input;
				_randCorrectOutputs[d] = _dataPackRand[d].output;
			}
			
			
			show_debug_message(string("inputs: {0}\n\n", _randInputs));
			show_debug_message(string("correct outputs: {0}\n\n", _randCorrectOutputs));
			
			
			//run through and train on all the randomized data in batches
			var _dataNum = array_length(_randInputs);
			var d = 0;
			var _batch = 0;
			while( d < _dataNum ) {
				_batch++;
				var _batchInputs = [];
				var _batchCorrectOutputs = [];
				for( var i = 0; i < _batchSize && d + i < _dataNum; i++ ) {
					_batchInputs[i] = _randInputs[d+i];
					_batchCorrectOutputs[i] = _randCorrectOutputs[d+i];
				}
				
				
				//average the input and output
				var _batchInputMatrix = Matrix.fromArray( _batchInputs );
				_batchInputMatrix = Matrix.transpose(_batchInputMatrix);
				var _batchTargetMatrix = Matrix.fromArray(_batchCorrectOutputs);
				_batchTargetMatrix = Matrix.transpose(_batchTargetMatrix);
		
				var _array = array_create(_batchInputMatrix.cols, 1)
				var _mult = Matrix.fromArray(_array);
				var _div = _batchInputMatrix.cols;
				_batchInputMatrix.multiplyDot(_mult);
				_batchInputMatrix.multiply(1/_div);
		
				var _array = array_create(_batchTargetMatrix.cols, 1)
				var _mult = Matrix.fromArray(_array);
				var _div = _batchTargetMatrix.cols;
				_batchTargetMatrix.multiplyDot(_mult);
				_batchTargetMatrix.multiply(1/_div);
		
				
				show_debug_message(string("batch {0}:", _batch));
				repeat(_epochs) {
		
					self.train( _batchInputMatrix, _batchTargetMatrix);
				}
				d += _batchSize;
			}
			
			show_debug_message(string("\n\nSGD complete. Trained from {0} batches.", _batch));
		}
	}
	
	/// @function                getOutputLargest( _output )
	/// @description			 returns the largest output neuron of the output array.  ONLY WORKS for single outputs (not the outputsArray returned by forwardprop_batch and backprop_batch)
	/// @param {array}		     _output	the array of output neurons from the neural network
	/// @return {int}			 the index of the largest output neuron
	static getOutputLargest = function( _output ) {
		if !is_array(_output) {
			show_error("_output is not an array", true);
			return;
		} else {
			//find the largest output neuron
			var _largestVal = 0;
			var _largestIdx = 0;
			for( var i = 0; i < array_length(_output); i++ )
			{
				if _output[i] > _largestVal {
					_largestVal = _output[i];
					_largestIdx = i;
					}
			}
		return _largestIdx;
		}
	}
	
	/// @function                oneHot( _number, _arraySize )
	/// @description			 returns one-hot encoded array corrisponding to _number (index _number = 1 and all other indecies = 0)
	/// @param {int}		     _number	the number to one-hot encode
	/// @param {int}			 _arraySize	the length that the array should be
	/// @return {array}			 the one-hot encoded array
	static oneHot = function( _number, _arraySize ) {
		var _array = array_create( _arraySize, 0 )
		_array[_number] = 1;
		return _array;
	}
	
	/// @function                getNeuralNetwork()
	/// @description			 returns a struct containing the weights and biases of the neural network
	/// @return {struct}		 a struct containing the weights under "weights" and biases under "biases"	 
	static getNeuralNetwork = function() {
		return {layerSizes : layerSizes, weights : weights, biases : biases, activationFunction : activationFunction, learningRate : learningRate, fitness: self.getFitness(), myId: myId, parentId: parentId};
	}
	
	/// @function                saveJson( _data, _name )
	/// @description			 saves data to a file in json format
	/// @param {any}		     _data	the data to save
	/// @param {string}			 _name	the name of the file
	static saveJson = function( _data, _name ) {
		var _jsonString = json_stringify(_data);
	    var _buffer = buffer_create(string_byte_length(_jsonString) + 1, buffer_fixed, 1);
	    buffer_write(_buffer, buffer_string, _jsonString);
	    buffer_save(_buffer, _name);
	    buffer_delete(_buffer);
	}
	
	/// @function                saveNeuralNetworkJson( _name )
	/// @description			 saves the neural network to a file in json format
	/// @param {string}			 _name	the name of the file
	static saveNeuralNetworkJson = function( _name ) {
		self.saveJson( getNeuralNetwork(), _name );
	}
	
	/// @function                loadJson( _name )
	/// @description			 loads data from a file in json format
	/// @param {string}			 _name	the name of the file
	/// @return {any}			 the parced data from the file
	static loadJson = function(_name) {

	    var buffer = buffer_load(_name);

	    if (buffer != -1) {
	        var _jsonString = buffer_read(buffer, buffer_string);

	        buffer_delete(buffer);

	        return json_parse(_jsonString);
	    } else {
	        return undefined;
	    }
	}

	/// @function                loadNeuralNetworkJson(_name)
	/// @description			 loads and inputs the neural network's data from a file in json format
	/// @param {string}			 _name	the name of the file
	static loadNeuralNetworkJson = function(_name) {
	    
		var _neuralNetData = loadJson(_name);
		
		if _neuralNetData = undefined {
			return undefined;
		} else {
			show_debug_message(_neuralNetData);
			var _nn = new NeuralNetwork( _neuralNetData.layerSizes );
			//set all of the neural network's variables
			for( var i = 1; i < _nn.layerNum; i++ ) {
				_nn.weights[i].copy(_neuralNetData.weights[i]);
				_nn.biases[i].copy(_neuralNetData.biases[i]);
			}
			_nn.fitness = _neuralNetData.fitness;
			_nn.learningRate = _neuralNetData.learningRate;
			_nn.myId = _neuralNetData.myId;
			_nn.parentId = _neuralNetData.parentId
			delete _neuralNetData;
			return _nn;
		}
	}
	
	static saveNeuralNetworkText = function( _fname) {
		var _jsonString = json_stringify(self.getNeuralNetwork());
		
		var _file = file_text_open_write(_fname);
		file_text_write_string(_file, _jsonString);
		file_text_close(_file);
	}
	
	static loadNeuralNetworkText = function( _fname ) {
		if(!file_exists(_fname)) {
			show_error("File " + string(_fname) + "not found", true);
			return;
		}
		var _file = file_text_open_read(_fname);
		var _jsonString = file_text_read_string(_file);
		file_text_close(_file);
		
		var _neuralNetData = json_parse(_jsonString);
		show_debug_message(_neuralNetData);
		
		var _nn = new NeuralNetwork( _neuralNetData.layerSizes );
		
		//set all of the neural network's variables
		for( var i = 1; i < _nn.layerNum; i++ ) {
			_nn.weights[i].copy(_neuralNetData.weights[i]);
			_nn.biases[i].copy(_neuralNetData.biases[i]);
		}
		_nn.fitness = _neuralNetData.fitness;
		_nn.learningRate = _neuralNetData.learningRate;
		_nn.myId = _neuralNetData.myId;
		_nn.parentId = _neuralNetData.parentId
		delete _neuralNetData;
		return _nn;
		
	}
		
		
	
	/// @function                duplicateNet()
	/// @description             returns a complete duplicate of the network
	/// @return {struct}		 a neural network that is a duplicate of the current one
	static duplicateNet = function() {
		
		var _nn = new NeuralNetwork( layerSizes );
		//set all of the neural network's variables
		for( var i = 1; i < layerNum; i++ ) {
			_nn.weights[i] = weights[i].duplicate();
			_nn.biases[i] = biases[i].duplicate();
		}
		_nn.activationFunction = activationFunction;
		_nn.learningRate = learningRate;
		_nn.fitness = fitness;
		_nn.parentId = myId;
		return _nn;
	}
		
	/// @function                mutate()
	/// @description             runs an inputted method on every weight and bias in the neural network
	/// @param {method}			 the method to run
	static mutate = function(_func) {
		for( var i = 1; i < layerNum; i++ ) {
			weights[i].map(_func);
			biases[i].map(_func);
		}
	}
	
}
