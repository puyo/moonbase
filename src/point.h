#ifndef POINT_H
#define POINT_H 1

class Point {
    public:
        Point(int x, int y): _x(x), _y(y) { }
    public:
        int x() const { return _x; }
        int y() const { return _y; }
    public:
        Point operator+(const Point& p) const {
            return Point(_x + p._x, _y + p._y);
        }

        Point operator-(const Point& p) const {
            return Point(_x - p._x, _y - p._y);
        }
    private:
        int _x;
        int _y;
};

#endif

