uses Algorithms;
var
  
  matrixExample := new real[3,4](
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
  
  transportTask: TransportTaskSolver := (
    rateMatrix: matrixExample;
    flagContent: flagContentExample;
    storagesVector: storagesVectorExample;
    shopsVector: shopsVectorExample;
  );
  
  storagesPotentials := new real[3](0,0,0);
  shopsPotentials := new real[4](0,0,0,0);
  
begin
  // составление плана
  writeln('---------------- Составление плана ----------------');
  var matrix:= transportTask.minTariffMethod();
  printMatrix(matrix);
  // оптимизация плана
  writeln('---------------- Оптимизация плана ----------------');
  while (true) do begin
    writeln('F = ', transportTask.calculateFunction(matrix));
  transportTask.findPotentials(storagesPotentials, shopsPotentials, matrix);
  writeln();
  var indeces := transportTask.checkPotentials(storagesPotentials, shopsPotentials, matrix);
  if(indeces.Item1 = -1) and (indeces.Item2 = -1) then
    break
  else
    transportTask.findContour(indeces, matrix);
  end;  
end.