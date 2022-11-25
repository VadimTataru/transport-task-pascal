unit Algorithms;

interface

type TransportTaskSolver = record
  rateMatrix: array[,] of real;
  storagesVector: array of real;
  shopsVector: array of real;
  
  //storageStrings: array of string;
  //shopStrings: array of string;
  
  public constructor Create(
    rateMatrix: array[,] of real;
    storagesVector: array of real;
    shopsVector: array of real
  );
  begin
    self.rateMatrix := rateMatrix;
    self.storagesVector := storagesVector;
    self.shopsVector := shopsVector;
    //storageStrings:= GetVectorStrings(storagesVector);
    //shopStrings:= GetVectorStrings(shopsVector);
  end;
  
  procedure Print;
  //function GetVectorStrings(vectorToString: array of real): array of string;
  
end;


function findIndecesOfMinRate(matrix: array[,] of real): (integer, integer);


//function GetVectorStrings(vectorToString: array of real): array of string;

//implement this
//function minTariffMethod();

implementation

procedure TransportTaskSolver.Print;
var charSpace: integer := 7;
begin
  Write('':charSpace, '│');
  for var i := 0 to self.shopsVector.Length do
    write('a' + i:charSpace );
  Writeln();
  Writeln('————————————————————————————————————————————————————');
  {for var i := 0 to self.baseMatrix.GetLength(0) - 1 do
  begin
    Write(self.columnStringX[i]:charSpace, '│');
    Write(self.baseMatrix[i, 0]:charSpace:2, '│');
    for var j := 1 to Length(self.baseMatrix, 1) - 1 do
      Write(self.baseMatrix[i, j]:charSpace:2);
    Writeln();
  end;}
end;


{function TransportTaskSolver.GetVectorStrings(vectorToString: array of real): array of string;
begin
  var len := vectorToString.Length;
  Result := new string[len];
  for var i := 0 to len do 
    Result[i]:= char(96+i);
end;
}

function findIndecesOfMinRate(matrix: array[,] of real): (integer, integer);
begin
  Result:= (0,0);
  
  for var i:= 0 to matrix.GetLength(0) - 1 do
    for var j:= 0 to matrix.GetLength(1) - 1 do
      if(matrix[i,j] < matrix[Result[0], Result[1]]) then
        Result:= (i, j);
  
end;  
end.