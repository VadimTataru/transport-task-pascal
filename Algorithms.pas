unit Algorithms;

interface

type TransportTaskSolver = record
  rateMatrix: array[,] of real;
  flagContent: array[,] of boolean;
  storagesVector: array of real;
  shopsVector: array of real;
  
  public constructor Create(
    rateMatrix: array[,] of real;
    flagContent: array[,] of boolean;
    storagesVector: array of real;
    shopsVector: array of real
  );
  begin
    self.rateMatrix := rateMatrix;
    self.flagContent := flagContent;
    self.storagesVector := storagesVector;
    self.shopsVector := shopsVector;
  end;
  
  procedure print;
  procedure findPotentials(storegesPotentials, shopsPotentials: array of real; matrix: array[,] of real);
  procedure findContour(startCell: (integer, integer); matrix: array[,] of real);
  
  function findMinContourElem(contourPath: array of integer; matrix: array[,] of real): real;
  function stepContour(prevCell: (integer, integer); contourPath: array of integer; mode: string): boolean;
  function checkPotentials(storegesPotentials, shopsPotentials: array of real; matrix: array[,] of real): (integer, integer);
  function minTariffMethod(): array[,] of real;
  function calculateFunction(matrix: array[,] of real): real;
  function findMinRate(prevIndeces: (integer, integer)): boolean;
  
end;

//functions
function findIndecesOfMinRate(matrix: array[,] of real): (integer, integer);
function getIndexOfMinInRow(matrix: array[,] of real; row: integer; member: array of real; isRowVertical: boolean): integer;
function isMemberEmpty(member: array of real): boolean;
function indexOfNaN(vector: array of real): integer;
function indexOfInt(vector: array of integer; val: integer): integer;

//procedires
procedure printMatrix(matrix: array[,] of real);
procedure printMatrixInt(matrix: array of integer);
procedure printVector(vector: array of real);
procedure fillVectorWithBool(vector: array of boolean; fillBy: boolean);
procedure fillVectorWithNaN(vector: array of real);
procedure fillVectorWithInteger(vector: array of integer; fillBy: integer);

implementation

//Self func and procedure. Start.

procedure TransportTaskSolver.print;
var charSpace: integer := 7;
begin
  Write('':charSpace, '│');
  for var i := 0 to self.shopsVector.Length do
    write('a' + i:charSpace );
  Writeln();
  Writeln('————————————————————————————————————————————————————');
end;

procedure TransportTaskSolver.findContour(startCell: (integer, integer); matrix: array[,] of real);
var multiplyer: integer;
begin
  var contourPath := new integer[(self.shopsVector.Length + self.storagesVector.Length) * 2];
  fillVectorWithInteger(contourPath, -1);
  contourPath[0] := startCell.Item1;
  contourPath[1] := startCell.Item2;
  
  var answer := stepContour(startCell, contourPath, 'hor');
  writeln('Контур');
  printMatrixInt(contourPath);
  var minElem := findMinContourElem(contourPath, matrix);
  
  for var i := 0 to contourPath.Length - 1 do
    if(contourPath[i] <> -1) and (contourPath[i+1] <> -1) and (i mod 2 = 0) then begin
      if (round(i / 2) mod 2 = 0) then multiplyer := 1 else multiplyer := -1;
      matrix[contourPath[i], contourPath[i+1]] := matrix[contourPath[i], contourPath[i+1]] + minElem * multiplyer;
      if(matrix[contourPath[i], contourPath[i+1]] > 0) then
        self.flagContent[contourPath[i], contourPath[i+1]] := false
      else
        self.flagContent[contourPath[i], contourPath[i+1]] := true;
    end;
  writeln();
  printMatrix(matrix);
end;

function TransportTaskSolver.findMinRate(prevIndeces: (integer, integer)): boolean;
begin
  if(self.storagesVector[prevIndeces.Item1] > 0) then begin
    for var i:= 0 to self.shopsVector.Length - 1 do
      if(self.flagContent[prevIndeces.Item1, i]) and (self.shopsVector[i] <> 0) then
        if(self.rateMatrix[prevIndeces.Item1, i] < self.rateMatrix[prevIndeces.Item1, prevIndeces.Item2] then
          prevIndeces.Item2 := i;
  end
  else if(self.shopsVector[prevIndeces.Item2] > 0) then begin
    for var j:=0 to self.storagesVector.Length - 1 do
      if(j, self.flagContent[prevIndeces.Item2]) and (self.storagesVector[j] <> 0) then
        if(self.rateMatrix[j, prevIndeces.Item2] < self.rateMatrix[prevIndeces.Item1, prevIndeces.Item2] then
          prevIndeces.Item1 := j;
  end
  else begin
    result:= true;
    exit;
  end;
  result:= false;
end;

function TransportTaskSolver.stepContour(prevCell: (integer, integer); contourPath: array of integer; mode: string): boolean;
begin
  var indexCell := (-1, -1);
  var firstFree := indexOfInt(contourPath, -1);
  
  if(mode = 'hor') then begin
    var flagFindAnswer := false;
    for var i := prevCell.Item2 + 1 to self.shopsVector.Length - 1 do begin
      if(not self.flagContent[prevCell.Item1, i]) then
        if(firstFree > -1) and (firstFree + 1 < contourPath.Length) then begin
          indexCell := (prevCell.Item1, i);
          contourPath[firstFree] := indexCell.Item1;
          contourPath[firstFree + 1] := indexCell.Item2;
          flagFindAnswer := stepContour(indexCell, contourPath, 'vert');
          if(not flagFindAnswer) then begin
            contourPath[firstFree] := -1;
            contourPath[firstFree + 1] := -1;
            indexCell := (-1, -1);
          end;
        end;
        if(indexCell.Item1 <> -1) and (indexCell.Item2 <> -1) then begin
          result:= true;
          exit;
        end;          
    end;
    if(not flagFindAnswer) then begin
      for var i := prevCell.Item2 - 1 downto 0 do begin
        if(not self.flagContent[prevCell.Item1, i]) then
          if(firstFree > -1) and (firstFree + 1 < contourPath.Length) then begin
            indexCell := (prevCell.Item1, i);
            contourPath[firstFree] := indexCell.Item1;
            contourPath[firstFree + 1] := indexCell.Item2;
            flagFindAnswer := stepContour(indexCell, contourPath, 'vert');
            if(not flagFindAnswer) then begin
              contourPath[firstFree] := -1;
              contourPath[firstFree + 1] := -1;
              indexCell := (-1, -1);
            end;
          end;
          if(indexCell.Item1 <> -1) and (indexCell.Item2 <> -1) then begin
            result:= true;
            exit;
          end;
      end;
    end;
  end;
  
  if(mode = 'vert') then begin
    var flagFindAnswer := false;
    for var j := prevCell.Item1 + 1 to self.storagesVector.Length - 1 do begin
      if(not self.flagContent[j, prevCell.Item2]) then
        if(firstFree > -1) and (firstFree + 1 < contourPath.Length) then begin
          indexCell := (j, prevCell.Item2);
          contourPath[firstFree] := indexCell.Item1;
          contourPath[firstFree + 1] := indexCell.Item2;
          flagFindAnswer := stepContour(indexCell, contourPath, 'hor');
          if(not flagFindAnswer) then begin
            contourPath[firstFree] := -1;
            contourPath[firstFree + 1] := -1;
            indexCell := (-1, -1);
          end;
        end;
        if(indexCell.Item1 <> -1) and (indexCell.Item2 <> -1) then begin
          result:= true;
          exit;
        end;          
    end;
    if(not flagFindAnswer) then begin
      for var j := prevCell.Item1 - 1 downto 0 do begin
        if(not self.flagContent[j, prevCell.Item2]) then
          if(firstFree > -1) and (firstFree + 1 < contourPath.Length) then begin
            indexCell := (j, prevCell.Item2);
            contourPath[firstFree] := indexCell.Item1;
            contourPath[firstFree + 1] := indexCell.Item2;
            flagFindAnswer := stepContour(indexCell, contourPath, 'hor');
            if(not flagFindAnswer) then begin
              contourPath[firstFree] := -1;
              contourPath[firstFree + 1] := -1;
              indexCell := (-1, -1);
            end;
          end;
          if(indexCell.Item1 <> -1) and (indexCell.Item2 <> -1) then begin
            result:= true;
            exit;
          end;
      end;
    end;
  end;
  if((prevCell.Item1 <> contourPath[2]) or (prevCell.Item2 <> contourPath[3])) 
      and ((prevCell.Item1 <> contourPath[0]) or (prevCell.Item2 <> contourPath[1])) then begin
        result:= true;
        exit;
      end;
  result:= false;
end;

function TransportTaskSolver.findMinContourElem(contourPath: array of integer; matrix: array[,] of real): real;
begin
  var minElem := integer.MaxValue;
  for var i := 0 to contourPath.Length - 1 do begin
    if (i mod 2 = 0) then begin
      var elem := integer.MaxValue;
      if(contourPath[i] <> -1) and (contourPath[i + 1] <> -1) then begin
        if (round(i / 2) mod 2 <> 0) then
          elem := round(matrix[contourPath[i], contourPath[i + 1]]);
      end
      else begin
        result := minElem;
        exit;
      end;
      if(not self.flagContent[contourPath[i], contourPath[i + 1]]) and (elem < minElem) then
        minElem := round(matrix[contourPath[i], contourPath[i + 1]]);
    end;
  end;
  result := minElem;
  exit;
end;

function TransportTaskSolver.minTariffMethod(): array[,] of real;
var
  k, s: integer;
begin
  Result:= new real[self.rateMatrix.GetLength(0), self.rateMatrix.GetLength(1)];
  //Шаг 1
  var indeces := findIndecesOfMinRate(self.rateMatrix);  
  k:= indeces.Item1;
  s:= indeces.Item2;  
  repeat
    //Шаг 2
    Result[k, s]:= min(self.storagesVector[k], self.shopsVector[s]);
    self.flagContent[k, s]:= false;
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

function TransportTaskSolver.calculateFunction(matrix: array[,] of real): real;
begin
  Result:= 0;
  for var i := 0 to self.storagesVector.Length - 1 do
    for var j := 0 to self.shopsVector.Length - 1 do
      Result := Result + (self.rateMatrix[i,j] * matrix[i,j]);
end;

procedure TransportTaskSolver.findPotentials(storegesPotentials, shopsPotentials: array of real; matrix: array[,] of real);
begin
  var strorageCount := self.storagesVector.Length;
  var shopsCount := self.shopsVector.Length;
  fillVectorWithNaN(storegesPotentials);
  fillVectorWithNaN(shopsPotentials);
  
  var storagesFlags := new boolean[strorageCount];
  var shopsFlags := new boolean[shopsCount];  
  fillVectorWithBool(storagesFlags, true);
  fillVectorWithBool(shopsFlags, true);
  
  storegesPotentials[0] := 0;
  shopsPotentials[0] := 0;
  storagesFlags[0] := false;
  while(true) do begin
    for var i := 0 to strorageCount - 1 do
      for var j := 0 to shopsCount - 1 do begin
        if shopsFlags[j] and (matrix[i, j] > 0) and not real.IsNaN(storegesPotentials[i]) then begin
          shopsPotentials[j] := self.rateMatrix[i,j] - storegesPotentials[i];
          shopsFlags[j] := false;
        end;
      end;
    for var j := 0 to shopsCount - 1 do
      for var i := 0 to strorageCount - 1 do begin
        if storagesFlags[i] and (matrix[i, j] > 0) and not real.IsNaN(shopsPotentials[j]) then begin
          storegesPotentials[i] := self.rateMatrix[i,j] - shopsPotentials[j];
          storagesFlags[i] := false;
        end;
      end;
    if (indexOfNaN(shopsPotentials) = -1) and (indexOfNaN(storegesPotentials) = -1) then
    break;
  end;
end;

function TransportTaskSolver.checkPotentials(storegesPotentials, shopsPotentials: array of real; matrix: array[,] of real): (integer, integer);
begin
  var minDiff := integer.MaxValue;
  Result := (-1, -1);
  
  for var i := 0 to self.storagesVector.Length - 1 do
    for var j := 0 to self.shopsVector.Length - 1 do begin
      if(matrix[i, j] = 0) then begin
        var diff := round(self.rateMatrix[i,j] - storegesPotentials[i] - shopsPotentials[j]);
        if(diff < 0) and (diff < minDiff) then begin
          minDiff := diff;
          result := (i, j);
        end;
      end;
    end;
end;

//Self func and procedure. End.

function findIndecesOfMinRate(matrix: array[,] of real): (integer, integer);
begin
  Result:= (0,0);  
  for var i:= 0 to matrix.GetLength(0) - 1 do
    for var j:= 0 to matrix.GetLength(1) - 1 do
      if(matrix[i,j] < matrix[Result[0], Result[1]]) then
        Result:= (i, j);  
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

function indexOfNaN(vector: array of real): integer;
begin
  for var i:= 0 to vector.Length - 1 do
    if(real.IsNaN(vector[i])) then begin      
      result:= i;
      exit;
    end;
    result:= -1;
end;

function indexOfInt(vector: array of integer; val: integer): integer;
begin
  for var i:= 0 to vector.Length - 1 do
    if(vector[i] = val) then begin      
      result:= i;
      exit;
    end;
    result:= -1;
end;

procedure printMatrix(matrix: array[,] of real);
begin
  for var i:= 0 to matrix.GetLength(0)-1 do begin
    for var j:= 0 to matrix.GetLength(1)-1 do
      write(matrix[i,j]:4);
    writeln();
  end;
end;

procedure printMatrixInt(matrix: array of integer);
begin
  for var i:= 0 to matrix.Length - 1 do begin
      write(matrix[i]:4);
  end;
end;

procedure printVector(vector: array of real);
begin
  for var i:= 0 to vector.Length - 1 do
    write(vector[i]);
end;

procedure fillVectorWithInteger(vector: array of integer; fillBy: integer);
begin
  for var i:= 0 to vector.Length - 1 do
    vector[i]:= fillBy;
end;

procedure fillVectorWithBool(vector: array of boolean; fillBy: boolean);
begin
  for var i:= 0 to vector.Length - 1 do
    vector[i]:= fillBy;
end;

procedure fillVectorWithNaN(vector: array of real);
begin
  for var i:= 0 to vector.Length - 1 do
    vector[i]:= real.NaN;
end;

end.