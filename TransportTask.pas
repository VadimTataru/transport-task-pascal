uses Algorithms;
var
  
  //First Example. Start
  {matrixExample := new real[3,4](
    (2, 1, 3, 2),
    (2, 3, 3, 1),
    (3, 3, 2, 1)
  );  
  flagContentExample := new boolean[3,4](
    (true, true, true, true), 
    (true, true, true, true), 
    (true, true, true, true)
  );  
  storagesVectorExample := new real[3](90, 70, 50);
  shopsVectorExample := new real[4](80, 60, 40, 30);
  
  storagesPotentials := new real[3](0,0,0);
  shopsPotentials := new real[4](0,0,0,0);
  //First Example. End}
  
  //Second Example. Start
  matrixExample := new real[4,5](
    (7, 1, 4, 5, 2),
    (13, 4, 7, 6, 3),
    (3, 8, 0, 18, 12),
    (9, 5, 3, 4, 7)
  );  
  flagContentExample := new boolean[4,5](
    (true, true, true, true, true), 
    (true, true, true, true, true),
    (true, true, true, true, true),
    (true, true, true, true, true)
  );  
  storagesVectorExample := new real[4](85, 112, 72, 120);
  shopsVectorExample := new real[5](75, 125, 64, 65, 60);
  
  storagesPotentials := new real[4](0,0,0,0);
  shopsPotentials := new real[5](0,0,0,0,0);
  //Second Example. End
  
  transportTask: TransportTaskSolver := (
    rateMatrix: matrixExample;
    flagContent: flagContentExample;
    storagesVector: storagesVectorExample;
    shopsVector: shopsVectorExample;
  );
  
  startIndeces: (integer, integer);
  
begin
  // составление плана
  var matrix := new real[transportTask.rateMatrix.GetLength(0), transportTask.rateMatrix.GetLength(1)];
  //startIndeces := findIndecesOfMinRate(transportTask.rateMatrix);
  startIndeces := (2, 2);
  writeln('---------------- Составление плана ----------------');
  while(true) do begin
    transportTask.step(startIndeces, matrix);
    //printMatrix(matrix); 
    var prevIndeces:= startIndeces;
    startIndeces := transportTask.findMinRate(prevIndeces);
    if(startIndeces = (-1,-1)) then
      break;
  end;
  //var matrix:= transportTask.minTariffMethod();
  printMatrix(matrix);  
  
  // оптимизация плана
  writeln('---------------- Оптимизация плана ----------------');
  while (true) do begin
    writeln();
    writeln('F = ', transportTask.calculateFunction(matrix));
  transportTask.findPotentials(storagesPotentials, shopsPotentials, matrix);
  writeln();
  var indeces := transportTask.checkPotentials(storagesPotentials, shopsPotentials, matrix);
  if(indeces.Item1 = -1) and (indeces.Item2 = -1) then
    break
  else begin
      transportTask.findContour(indeces, matrix);
    end;    
  end;
  
  writeln('---------------- Ответ ----------------');
  writeln();
  writeln('---------------- Конечный план ----------------');
  printMatrix(matrix);
  writeln();
  writeln('F = ', transportTask.calculateFunction(matrix));
  
end.