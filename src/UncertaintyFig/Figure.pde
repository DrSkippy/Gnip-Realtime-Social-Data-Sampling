import processing.pdf.*;

figure_un f;

int x_size = 650;
int y_size = 350;
// fig 2
// int y_size = 650;
int arrow_size = 6;
// for conf 95%
float z_alpha = 1.95;
int baseline_color = 0xFF00FF00;
int line_color = 0xFF0000FF;
int point_color = 0xFFFF0000;
int axis_color = 0xFF000000;
int bg_color = 0xFFFFFFFF;

void setup() {
  //f = new figure_sig("fig3a.pdf", 10, 0);
  f = new figure_sig("fig3b.pdf", 5, 2.1568828);
  //f = new figure_un("fig2.pdf", 40);
  //size(x_size, y_size);
  size(x_size, y_size, PDF, f.name);
  background(bg_color);
  textMode(SHAPE);
}

void draw() {
  //String[] fontList = PFont.list();
  //println(fontList);
  int x_axis = x_size - 100;
  int y_axis = y_size - 100;
  f.axes(100, x_axis, y_axis);
  // fig 2
  // f.conf_curve(100, int(0.98*(x_axis-100)), int(0.95*(y_axis-100)));
  //
  // fig 3a,b
  f.conf_curve(100, int(0.98*(x_axis-100)), int(0.95*(y_axis-100)));
  exit();
  println(f.dy);
}

