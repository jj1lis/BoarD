#include <set>
#include <map>

using namespace std;

struct Coordinate{
    private:
    int _raw;
    int _column;

    public:
    inline auto raw(){return _raw;}
    inline auto column(){return _column;}

    Coordinate(int t_raw,int t_column){
        _raw=t_raw;
        _column=t_column;
    }
};

template <typename T_Piece> class Board{
    private:
        map<Coordinate,T_Piece> _squares;
        set<Coordinate> _exists_squares;

        //TODO
};
