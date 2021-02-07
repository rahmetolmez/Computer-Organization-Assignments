/* CheckSumPossibility
   Author: Rahmet Ali Olmez
   November 2020
*/
#include<iostream>

using namespace std;

#define MAX_SIZE 100

int CheckSumPossibility(int num, int arr[], int size);

int main()
{
	int arraySize;
	int arr[MAX_SIZE];
	int num;
	int returnVal;
	
	cin >> arraySize;
	cin >> num;
	
	for(int i = 0; i < arraySize; ++i)
	{
		cin >> arr[i];
	}
	
	returnVal = CheckSumPossibility(num, arr, arraySize);
	
	if(returnVal == 1)
	{
		cout << "Possible!" << endl;
	}
	else
	{
		cout << "Not possible!" << endl;
	}

	return 0;
}

int CheckSumPossibility(int num, int arr[], int size)
{
	if(num == 0)
	{	
		return 1;
	}

	if(num < 0)
	{
		return 0;
	}

	if(size == 1)
		if(num == arr[0])
			return 1;
		else
		{
			return 0;
		}

	if(CheckSumPossibility(num - arr[size - 1], arr, size - 1) == 1)
		return 1;

	if(CheckSumPossibility(num, arr, size - 1))
		return 1;

	return 0;
}
