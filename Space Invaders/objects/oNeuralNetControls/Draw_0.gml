
draw_text_transformed(XMAX + 10, YMIN, "Population Size: " + string(array_length(ne.population)), 0.5, 0.5, 0);
draw_text_transformed(XMAX + 10, YMIN + 10, "Generation: " + string(ne.generation), 0.5, 0.5, 0);
draw_text_transformed(XMAX + 10, YMIN + 20, "Current Neural Network: " + string(ne.currentNeuralNet.myId), 0.5, 0.5, 0);
draw_text_transformed(XMAX + 10, YMIN + 30, "Best Neural Network: ID " + string(ne.bestNeuralNet.myId) + ",", 0.5, 0.5, 0);
draw_text_transformed(XMAX + 10, YMIN + 40, "Fitness: " + string(ne.bestNeuralNet.getFitness()), 0.5, 0.5, 0);

draw_text_transformed(XMAX + 10, YMIN + 60, "S to change speed", 0.5, 0.5, 0);
draw_text_transformed(XMAX + 10, YMIN + 70, "E to stop training", 0.5, 0.5, 0);
