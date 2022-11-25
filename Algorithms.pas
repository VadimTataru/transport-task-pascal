﻿unit Algorithms;

interface

type TransportTaskSolver = record
  rateMatrix: array[,] of real;
  storagesVector: array of real;
  shopsVector: array of real;
  
  public constructor Create(
    rateMatrix: array[,] of real;
    storagesVector: array of real;
    shopsVector: array of real
  );
  begin
    self.rateMatrix := rateMatrix;
    self.storagesVector := storagesVector;
    self.shopsVector := shopsVector;
  end;
  
  procedure Print;  
  function minTariffMethod(): array[,] of real;
  function calculateFunction(matrix: array[,] of real): real;
  
end;

//functions
function findIndecesOfMinRate(matrix: array[,] of real): (integer, integer);
function getIndexOfMinInRow(matrix: array[,] of real; row: integer; member: array of real; isRowVertical: boolean): integer;
function isMemberEmpty(member: array of real): boolean;

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
end;

function findIndecesOfMinRate(matrix: array[,] of real): (integer, integer);
begin
  Result:= (0,0);  
  for var i:= 0 to matrix.GetLength(0) - 1 do
    for var j:= 0 to matrix.GetLength(1) - 1 do
      if(matrix[i,j] < matrix[Result[0], Result[1]]) then
        Result:= (i, j);  
end;

function TransportTaskSolver.minTariffMethod(): array[,] of real;
var
  k, s: integer;
  flag:= true;
begin
  Result:= new real[self.rateMatrix.GetLength(0), self.rateMatrix.GetLength(1)];
  //Шаг 1
  var indeces := findIndecesOfMinRate(self.rateMatrix);  
  k:= indeces.Item1;
  s:= indeces.Item2;  
  repeat
    //Шаг 2
    Result[k, s]:= min(self.storagesVector[k], self.shopsVector[s]);    
    //Шаг 3
    self.storagesVector[k] -= Result[k,s];
    self.shopsVector[s] -= Result[k,s];
    //Шаг 4
    if(self.storagesVector[k] = 0) then begin
      k:= getIndexOfMinInRow(self.rateMatrix, s, self.storagesVector, true);
      if(self.shopsVector[s] = 0) then
        s:= getIndexOfMinInRow(self.rateMatrix, k, self.shopsVector, false);
    end
    //Шаг 6
    else if(self.shopsVector[s] = 0) then begin
      s:= getIndexOfMinInRow(self.rateMatrix, k, self.shopsVector, false);
      if(self.storagesVector[k] = 0) then
        k:= getIndexOfMinInRow(self.rateMatrix, s, self.storagesVector, true);
    end;
  until (isMemberEmpty(self.storagesVector) = false) and (isMemberEmpty(self.shopsVector) = false);
end;

function isMemberEmpty(member: array of real): Boolean;
begin
  var count:= 0;
  for var i:= 0 to member.Length - 1 do
    if(member[i] <> 0) then begin
      count:= count + 1;
    end;
  if(count = 0) then
    Result:= false
  else
    Result:= true;
end;

function getIndexOfMinInRow(matrix: array[,] of real; row: integer; member: array of real; isRowVertical: boolean): integer;
begin
  if(isRowVertical) then begin
    Result:= 0;
    for var i:=0 to member.Length-1 do begin
      if(matrix[i, row] <= matrix[Result, row]) and (member[i] > 0) then begin
          Result:= i;
      end;
    end;
  end
  else begin
    Result:= 0;
    for var j:=0 to member.Length -1 do
      if(matrix[row, j] <= matrix[row, Result]) and (member[j] > 0) then begin
        Result:= j;
      end;
  end;         
end;

function TransportTaskSolver.calculateFunction(matrix: array[,] of real): real;
begin
  Result:= 0;
  for var i := 0 to self.storagesVector.Length - 1 do
    for var j := 0 to self.shopsVector.Length - 1 do
      Result := Result + (self.rateMatrix[i,j] * matrix[i,j]);
end;

procedure printMatrix(matrix: array[,] of real);
begin
  for var i:= 0 to matrix.GetLength(0)-1 do begin
    for var j:= 0 to matrix.GetLength(1)-1 do
      write(matrix[i,j]:4);
    writeln();
  end;
end;  

end.