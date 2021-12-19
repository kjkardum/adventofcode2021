#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <string>
#include <sstream>

using namespace std;

vector<int> roll(vector<int> v) { 
    vector<int> ret;
    ret.push_back( v[0]);
    ret.push_back( v[2]);
    ret.push_back(-v[1]);
    return ret;
};
vector<int> turn(vector<int> v) {
    vector<int> ret;
    ret.push_back(-v[1]);
    ret.push_back( v[0]);
    ret.push_back( v[2]);
    return ret;

};
vector<int> sequence(vector<int> v, int n) {
    int x=0;
    for (int cycle=0; cycle < 2; cycle++) {
        for(int step=0; step<3; step++) { // Yield RTTT 3 times
            v = roll(v);
            if ((x++)==n) return v;       //    Yield R
            for (int i=0; i< 3; i++) { //    Yield TTT
                v = turn(v);
                if ((x++)==n) return v;
            }
        }
        v = roll(turn(roll(v))); // Do RTR
    }
    return v;
};
vector< vector< vector< int > > >* inputFile(string filename) {
    vector< vector< vector< int > > > *data = new vector< vector< vector< int > > >(38, vector< vector< int > >(0, vector< int >(3)));
    ifstream file(filename);
    string line;
    int scanner_num = 0;
    while (getline(file, line)) {
        if (line.find("scanner") != string::npos) {
            continue;
        }
        if (line.empty()) {
            scanner_num++;
            continue;
        }
        vector<int> scanner_line;
        stringstream ss(line);
        string coordinate;
        while (getline(ss, coordinate, ',')) {
            scanner_line.push_back(stoi(coordinate));
        }
        (*data)[scanner_num].push_back(scanner_line);
    }

    return data;
}
vector< vector<int> > find_intersection(vector< vector<int> > v, vector< vector<int> > v2) {
    // find intersection between sets of coordinates, v adn v2
    vector< vector<int> > ret;
    for (int i=0; i<v.size(); i++) {
        for (int j=0; j<v2.size(); j++) {
            if (v[i][0] == v2[j][0] && v[i][1] == v2[j][1] && v[i][2] == v2[j][2] && find(ret.begin(), ret.end(), v[i]) == ret.end()) {
                ret.push_back(v[i]);
            }
        }
    }
    return ret;
}
vector< vector<int> > translate_vector(vector< vector< int > > v, vector < int > coords) {
    // move every coordinate in v by coords
    vector< vector<int> > ret;
    for (int i=0; i<v.size(); i++) {
        vector<int> new_coord;
        for (int j=0; j<v[i].size(); j++) {
            new_coord.push_back(v[i][j]+coords[j]);
        }
        ret.push_back(new_coord);
    }
    return ret;
}
vector<int> coord_distance(vector<int> from, vector<int> to) {
    // find distance between two coordinates
    vector<int> ret;
    for (int i=0; i<from.size(); i++) {
        ret.push_back(from[i]-to[i]);
    }
    return ret;
}
vector<int> checkRotation(vector< vector< vector<int> > > *data, int from, int to, int rotation) {
    // try every translation from distance of coordinates until we find match
    // if we find match, then we have found the rotation and can return true, and maybe also the translation
    vector< vector<int> > toV;
    for(int i=0; i<(*data)[to].size(); i++) {
        toV.push_back(sequence((*data)[to][i], rotation));
    }
    for(int i=0; i<(*data)[from].size(); i++) {
        for (int j=0; j<(*data)[to].size(); j++) {
            vector<int> dist = coord_distance((*data)[from][i], toV[j]);
            vector< vector<int> > v = translate_vector(toV, dist);
            vector< vector<int> > v2 = find_intersection(v, (*data)[from]);
            if (v2.size() >= 12) {
                return dist;
            }
        }
    }
    return vector<int>(0,0);
}
int findNextSensor(vector< vector< vector<int> > > *data, int from, vector<int> *visited, vector< vector<int> > *sensor_locations) {
    // try every sensor, try every rotation and if it works, return sensor and its rotation
    // it will them be saved rotated outside function and new one will be called from it
    for(int i=0; i< data->size(); i++) {
        cout << "nextSensorTest " << i << endl;
        if (find(visited->begin(), visited->end(), i) != visited->end()) continue;
        for(int r=0; r< 24; r++) {
            //cout << "rotationTest " << r << endl;
            vector<int> v = checkRotation(data, from, i, r);
            if (v.size() > 0) {
                // rotate  everything in data[i] by sequence(data[i][j], r) and then translate by v. Then add i to visited and return it
                for (int j=0; j< (*data)[i].size(); j++) {
                    (*data)[i][j] = sequence((*data)[i][j], r);
                }
                (*data)[i] = translate_vector((*data)[i], v);
                sensor_locations->push_back(v);
                visited->push_back(i);
                return i;
            }
        }
    }
    return -1;
}

bool checkEq(vector<int> a, vector<int> b) {
    if (a.size() != b.size()) return false;
    for (int i=0; i<a.size(); i++) {
        if (a[i] != b[i]) return false;
    }
    return true;
};

int main(void) {
    vector< vector< vector< int > > > *data = inputFile("input.txt");
    vector<int> visited;
    vector< vector<int> > sensor_locations;
    vector<int> start_vec;
    start_vec.push_back(0);
    start_vec.push_back(0);
    start_vec.push_back(0);
    sensor_locations.push_back(start_vec);
    visited.push_back(0);
    while (visited.size() < data->size()) {
        int next = -1;
        int i = visited.size()-1;
        while (next == -1) {
            if (i < 0) {
                cout << "!!!!!!!!!!!!" << endl;
                break;
            }
            next = findNextSensor(data, visited[i], &visited, &sensor_locations);
            cout << "next " << next << endl;
            if (next == -1) {
                cout << "visited before: ";
                for (int i=0; i<visited.size(); i++) {
                    cout << visited[i] << " ";
                }
                cout << endl;
                int toMove = visited[i];
                visited.erase(visited.begin()+i);
                visited.insert(visited.begin(), toMove);
            }
            cout << "visited: ";
            for (int i=0; i<visited.size(); i++) {
                cout << visited[i] << " ";
            }
            cout << endl;
            i--;
        }
    }
    vector< vector<int> > flattened;
    for (int i = 0; i< 38; i++) {
        for (int j = 0; j< (*data)[i].size(); j++) {
            flattened.push_back((*data)[i][j]);
        }
    }
    vector< vector<int> >::iterator ip;
  
    ip = unique(flattened.begin(), flattened.end(), checkEq);
    flattened.resize(distance(flattened.begin(), ip));
    for (int i = 0; i < flattened.size(); i++) {
        cout << flattened[i][0] << ", " << flattened[i][1] << ", " << flattened[i][2] << endl;
    }
    cout << "sensor_locations: " << endl;
    for (int i = 0; i < sensor_locations.size(); i++) {
        cout << sensor_locations[i][0] << ", " << sensor_locations[i][1] << ", " << sensor_locations[i][2] << endl;
    }
    //Find largest manhattan distance between any two sensors
    int max = 0;
    for (int i = 0; i < sensor_locations.size(); i++) {
        for (int j = i+1; j < sensor_locations.size(); j++) {
            int dist = 0;
            for (int k = 0; k < sensor_locations[i].size(); k++) {
                dist += abs(sensor_locations[i][k] - sensor_locations[j][k]);
            }
            if (dist > max) {
                max = dist;
            }
        }
    }
    cout << "part 2: " << max << endl;
    return 0;
}