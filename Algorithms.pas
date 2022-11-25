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

//functions
function findIndecesOfMinRate(matrix: array[,] of real): (integer, integer);


//function GetVectorStrings(vectorToString: array of real): array of string;

function minTariffMethod(matrix: array[,] of real; storages: array of real;  shops: array of real): array[,] of real;
function getIndexOfMinInRow(matrix: array[,] of real; row: integer; isRowVertical: boolean): integer;
function isMemberEmpty(member: array of real): Boolean;

//procedires
procedure printMatrix(matrix: array[,] of real);

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

function minTariffMethod(matrix: array[,] of real; storages: array of real;  shops: array of real): array[,] of real;
var
  k, s: integer;
  flag:= true;
begin
  Result:= new real[matrix.GetLength(0), matrix.GetLength(1)];
  //Шаг 1
  var indeces := findIndecesOfMinRate(matrix);  
  k:= indeces.Item1;
  s:= indeces.Item2;
  
  repeat
    writeln('D:');
    //Шаг 2
    Result[k, s]:= min(storages[k], shops[s]);    
    //Шаг 3
    storages[k] -= Result[k,s];
    shops[s] -= Result[k,s];
    //Шаг 4
    if(storages[k] = 0) then begin
      k:= getIndexOfMinInRow(matrix, s, true);
        continue;
    end
    //Шаг 6
    else begin
      s:= getIndexOfMinInRow(matrix, k, false);
      continue;
    end;
  until (isMemberEmpty(storages) = true) and (isMemberEmpty(shops) = true);
  
  {while(flag) do begin
    //Шаг 2
    Result[k, s]:= min(storages[k], shops[s]);
    
    //Шаг 3
    storages[k] -= Result[k,s];
    shops[s] -= Result[k,s];
    
    //Шаг 4
    if(storages[k] = 0) then begin
      //Шаг 7
      if(isMemberEmpty(storages)) then flag:= false
      //Шаг 8
      else begin
        k:= getIndexOfMinInRow(matrix, s, true);
        continue;
      end;    
    end
    //Шаг 5
    else if(isMemberEmpty(shops)) then flag:= false
    //Шаг 6
    else begin
      s:= getIndexOfMinInRow(matrix, k, false);
      continue;
    end;
  end;}
end;    

function isMemberEmpty(member: array of real): Boolean;
begin  
  for var i:= 0 to member.Length do
    if(member[i] <> 0) then begin
      Result:= false;
    end;
  Result:= true;
end;

function getIndexOfMinInRow(matrix: array[,] of real; row: integer; isRowVertical: boolean): integer;
begin
  Result:= 0;
  if(isRowVertical) then
    for var i:=1 to matrix.GetLength(0)-1 do
      if(matrix[i, row] < matrix[Result, row]) then
        Result:= i
  else
    for var j:=1 to matrix.GetLength(1) -1 do
      if(matrix[row, j] < matrix[row, Result]) then
        Result:= j;      
end;

procedure printMatrix(matrix: array[,] of real);
begin
  for var i:= 0 to matrix.GetLength(0)-1 do begin
    for var j:= 0 to matrix.GetLength(1)-1 do
      write(matrix[i,j]:4);
  end;
  writeln();
end;  

end.