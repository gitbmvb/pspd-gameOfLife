#include <bits/stdc++.h>
using namespace std;

bool valid_coordinates(int n, int x, int y) {
    if (x < 0 || x >= n || y < 0 || y >= n) return false;
    return true;
}

int count_neighbors(vector<vector<int>>& matrix, int size, int x, int y) {
    int counter = 0;
    for (int i = x - 1; i <= x + 1; i++) {
        for (int j = y - 1; j <= y + 1; j++) {
            if ((i != x || j != y) && valid_coordinates(size, i, j) && matrix[i][j]) counter++;
        }
    }
    return counter;
}

void print_matrix(vector<vector<int>> matrix, int size) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++)
            cout << (matrix[i][j] ? "x":"o") << " ";
        cout << "\n";
    }
}

int main(void) {
    const int n = 5;
    int generations = 15, current_generation = 0;
    vector<vector<int>> matrix (n);
    for (auto& line : matrix) line = vector<int> (n, 0);

    matrix[2][1] = matrix[2][2] = matrix[2][3] = 1;
    int neighbors;

    vector<vector<int>> next_matrix = matrix;

    while(current_generation < generations) {
        cout << "\033[2J\033[H";
        cout << "Generation " << current_generation++ << ":\n";
        print_matrix(matrix, n);
        cout << "\n";
        
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                neighbors = count_neighbors(matrix, n, i, j);
                if (matrix[i][j] && (neighbors < 2 || neighbors > 3)) next_matrix[i][j] = 0;
                else if (!matrix[i][j] && neighbors == 3) next_matrix[i][j] = 1;
            }
        }
        matrix = next_matrix;
        sleep(1);
    }
}