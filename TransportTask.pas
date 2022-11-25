uses Algorithms;
var
  
  matrixExample := new real[3,4](
    (2, 1, 3, 2),
    (2, 3, 3, 1),
    (3, 3, 2, 1)
  );  
  storagesVectorExample := new real[3](90, 70, 50);
  shopsVectorExample := new real[4](80, 60, 40, 30);
  
  transportTask: TransportTaskSolver := (
    rateMatrix: matrixExample;
    storagesVector: storagesVectorExample;
    shopsVector: shopsVectorExample;
  );

begin
  var tempMatrix:= transportTask.minTariffMethod();
  writeln(transportTask.calculateFunction(tempMatrix));
end.