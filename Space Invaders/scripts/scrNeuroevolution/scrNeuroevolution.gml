


//the neuroevolution-running struct

//contains methods:

//start( _populationSize, _numGenerations, _neuralNetSizesArray, _eliteNum, _mutateNum, _mutationRate )

//getOutput( _inputs )
	//returns the result of forwardprop with the current neural network
	
//step( _currentNeuralNetFitness, _continueTest )
	//general step event for neuroevolution
	
	//if currently training
		//update the current neural network's fitness
	
		//if _continueTest == false //the player has died, etc
			//if there are more networks to test in this generation
				//get the next neural network
				//return
			//else
				//if generation < numGenerations
					//move on to the next generation
						//sort the population from smallest to largest fitness
						//keep the specified amount of the best networks to save unchanged as elite
						//fill the rest of the population with mutated versions of the specified number of best neural networks
						//generation++
				//else
					//end the session
					//set current neural network to the best of the generation
					
					
//population[]
//generation = 0
//numGenerations = 0
//neuralNetSizesArray = []
//eliteNum = 0
//mutateNum = 0
//mutationRate = 0
//training = false


				
function Neuroevolution( _populationSize, _neuralNetSizesArray, _mutationRate, _testsPerNeuralNet ) constructor {
	
	//initialize the variables
	population = array_create( _populationSize, undefined );
	for( var i = 0; i < array_length(population); i++ ) {
		population[i] = new NeuralNetwork( _neuralNetSizesArray );
	}
	//layerSizesArray = _neuralNetSizesArray;
	//eliteNum = _eliteNum;
	//mutateNum = _mutateNum;
	mutationRate = _mutationRate;
	numTests = _testsPerNeuralNet;
	currentNeuralNet = population[0];
	bestNeuralNet = population[0];
	popNum = 0;
	generation = 0;
	counter = 0;
	show_debug_message("started neuroevolution");
	show_debug_message("\nGeneration " + string(generation) + ":");
	show_debug_message("The time is " + string(current_hour) + ":" + string(current_minute) + "." + string(current_second));
	show_debug_message("Neural Network " + string(popNum) + " ID: " + string(currentNeuralNet.myId) + " Parent ID: " + string(currentNeuralNet.parentId));
	training = true;
	

	
	static getOutput = function( _inputs ) {
		if currentNeuralNet == undefined {
			return undefined;
		}
		
		return currentNeuralNet.forwardprop(_inputs);
	}
			
		
	static step = function( _currentNeuralNetFitness, _continueTest ) {
		if(training) {
			if(!_continueTest) {
				if( counter == 0) {
					currentNeuralNet.setFitness(0);
				}
				currentNeuralNet.setFitness( currentNeuralNet.getFitness() + (_currentNeuralNetFitness/numTests));
				counter++;
				if(counter >= numTests) {
					counter = 0;
					show_debug_message("Fitness: " + string(currentNeuralNet.getFitness()));
					popNum++;
					if(!(popNum < array_length(population))) {
						generation++;
						
						self.naturalSelection();
						
						
						
						for( var i = 0; i < array_length(population); i++ ) {
							show_debug_message("Neural Network " + string(i) + " ID: " + string(population[i].myId) + " Parent ID: " + string(population[i].parentId) + " fitness: " + string(population[i].getFitness()));
						}
						
						currentNeuralNet = population[0];
						popNum = 0;
					
					
						show_debug_message("\nGeneration " + string(generation) + ":");
						show_debug_message("The time is " + string(current_hour) + ":" + string(current_minute) + "." + string(current_second));
						show_debug_message("Neural Network " + string(popNum) + " ID: " + string(currentNeuralNet.myId) + " Parent ID: " + string(currentNeuralNet.parentId));
					
					} else {
						currentNeuralNet = population[popNum];
						show_debug_message("Neural Network " + string(popNum) + " ID: " + string(currentNeuralNet.myId) + " Parent ID: " + string(currentNeuralNet.parentId));
					}
				}
			}
		}
	}
	
	static naturalSelection = function() {
		//also get the best neural network of the generation
		var _bestFitness = 0;
		var _bestIndex = 0;
						
		for( var i = 0; i < array_length(population); i++ ) {
			if( population[i].getFitness() > _bestFitness) {
				_bestFitness = population[i].getFitness();
				_bestIndex = i;
			}
		}
		
		
		//save the best network
		if(population[_bestIndex].getFitness() > bestNeuralNet.getFitness()) {
			bestNeuralNet = population[_bestIndex];
			//show_debug_message(string(bestNeuralNet));
			bestNeuralNet.saveNeuralNetworkText(working_directory + "NeuroevolutionBestNeuralNetwork.txt" );
			//show_debug_message(working_directory + "NeuroevolutionBestNeuralNetwork.txt" );
			show_debug_message("____New best: Neural Network " + string(bestNeuralNet.myId) + " fitness: " + string(bestNeuralNet.getFitness()) + "  Saved to JSON____");
		}
		
						
		//normalize the fitnesses for each neural network
		var _sum = 0;
						
		for( var i = 0; i < array_length(population); i++ ) {
			//square all of the populations to get accentuate varience
			population[i].prob = (power(population[i].getFitness(), 2));
			_sum += population[i].prob;
		}
						
		for( var i = 0; i < array_length(population); i++ ) {
			show_debug_message("inital fitness for neural net " + string(i) + ": " + string(population[i].prob));
			population[i].prob = (population[i].prob/_sum);
			show_debug_message("normalized fitness for neural net " + string(i) + ": " + string(population[i].prob));
		}
						
		var _sum = 0;
		for( var i = 0; i < array_length(population); i++ ) {
			_sum += population[i].prob;
		}
		show_debug_message("sum of normalized probablities: " + string(_sum));
		
		var _newPopulation = array_create(array_length(population), undefined);
		
		_newPopulation[0] = bestNeuralNet.duplicateNet();
		show_debug_message("best neural net duplicated as Neural Net 0: ID " + string(bestNeuralNet.myId) + " fitness " + string(bestNeuralNet.getFitness()));
		
		for( var i = 1; i < array_length(_newPopulation); i++ ) {
			//pick a neural net using the normalized fitnesses as probibilities
			var _num = random(1);
			show_debug_message("random number: " + string(_num));
			var _index = -1;
			while(_num > 0) {
				_index++;
				_num -= population[_index].prob;
			}
			_index = max(_index,0);
			show_debug_message("neural network's index: " + string(_index));
							
			//set the new neural network and mutate it
			_newPopulation[i] = population[_index].duplicateNet();
			var _mutate = function( _element ) {
				if(random(1) < mutationRate) {
					//returns the average of the element and a gaussian distribution
					//show_debug_message("Mutation: inital val: " + string(_element) + " mutated val: " + string((_element + gauss( 0, 1))/2));
					return (_element + gauss( 0, 1))/2;
									
				}
				return _element;
			}
			_newPopulation[i].mutate(_mutate);
		}

			
		population = _newPopulation;
	}
			
	static stop = function() {
		if(training) {
			show_debug_message("Neuroevolution Complete:\npopulation: " + string(array_length(population)) + "\ngenerations: " + string(generation) + "\nreal time: " + string(current_hour) + ":" + string(current_minute) + "." + string(current_second));
			show_debug_message("Best Neural Network ");
			show_debug_message(string( bestNeuralNet));
	
						
			show_message("Neuroevolution Complete!");
			training = false;
		}
	}
	
	static stopCurrentIsBest = function() {
		if(training) {
			bestNeuralNet = currentNeuralNet;
			self.stop();
		}
	}
			
		
			
	static getBest = function() {
		return bestNeuralNet;
	}
}