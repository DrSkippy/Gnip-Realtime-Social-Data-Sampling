class figure_un {

  String name;
  float dy;
  int n;
  PFont font;

  figure_un(String _name, int _n) {
    name = _name;
    n = _n;
  } 

  void s_arrow(int x1, int y1, int x2, int y2, int s_width) {
    // line (x1, y1) (x2, y2) points at the object, and defines the length of the arrow
    // s_width defines the width of the arrow
    int s_length = 2*int(sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2)));
    noFill();
    pushMatrix();
    translate(x1 + offset, y_size - (y1 + offset));
    float a = atan2(y2-y1, x2-x1);
    rotate(-a);
    bezier(squiggle*s_length, -s_width, -(1. - squiggle)*s_length, -s_width, s_length, 0, 0, 0);
    line(0, 0, arrow_size, -arrow_size);
    line(0, 0, arrow_size, arrow_size);
    popMatrix();
  }

  void arrow(int x1, int y1, int x2, int y2) {
    y1 = y_size - y1;
    y2 = y_size - y2;
    line(x1, y1, x2, y2);
    pushMatrix();
    translate(x2, y2);
    float a = atan2(x1-x2, y2-y1);
    rotate(a);
    line(0, 0, -arrow_size, -arrow_size);
    line(0, 0, arrow_size, -arrow_size);
    popMatrix();
  } 

  void axes(int x_axis, int x_width, int y_height) {
    strokeWeight(int(line_weight*1.5));
    stroke(axis_color);
    arrow(x_axis, x_axis, x_width, x_axis);
    arrow(x_axis, x_axis, x_axis, y_height);
    //
    font = createFont("BookAntiqua-Bold-24.vlw", 24);
    textFont(font, 24);
    textAlign(CENTER, BOTTOM);
    //
    fill(0);
    pushMatrix();
    translate(text_offset, y_size - (x_axis + y_height)/2);
    rotate(-PI/2); 
    text("Activity Rate", 0, 0); 
    popMatrix();
    textAlign(CENTER, TOP);
    text("Time", (x_axis + x_width)/2, y_size - text_offset);
  }

  float poisson_lbounds(int k) {
    return k*pow(1. - 1./(9.*k) - z_alpha/(3.*sqrt(k)), 3.);
  }

  float poisson_ubounds(int k) {
    return (k+1.)*pow(1. - 1./(9.*(k+1.)) + z_alpha/(3.*sqrt(k+1.)), 3.);
  }

  void conf_curve(int x_origin, int x_pixels, int y_pixels) {
    float x;
    float yu;
    float yl;
    //
    // settings
    strokeWeight(line_weight);
    float dx = x_pixels/n;
    dy = y_pixels/poisson_ubounds(1);
    // 
    // first point
    float x_last = dx;
    float yu_last = poisson_ubounds(1)/1. * dy;
    float yl_last = poisson_lbounds(1)/1. * dy;
    //
    stroke(baseline_color);
    line(x_origin + x_last, y_size - (x_origin + 1*dy), x_origin + n*dx, y_size - (x_origin + 1*dy));
    stroke(point_color);
    point(x_origin + x_last, y_size - (x_origin + yu_last));
    point(x_origin + x_last, y_size - (x_origin + yl_last));
    //
    for (int i=1;i<=n;i++) {
      x = i * dx;
      yu = poisson_ubounds(i)/i * dy;
      yl = poisson_lbounds(i)/i * dy;
      stroke(line_color);
      line(x_origin + x_last, y_size - (x_origin + yu_last), x_origin + x, y_size - (x_origin + yu));
      line(x_origin + x_last, y_size - (x_origin + yl_last), x_origin + x, y_size - (x_origin + yl));
      stroke(point_color);
      //point(x_origin + x, y_size - (x_origin + yu));
      //point(x_origin + x, y_size - (x_origin + yl));
      x_last = x;
      yu_last = yu;
      yl_last = yl;
    }
    // Annotations on top
    fill(0);
    stroke(marker_color);
    int temp_n = n-3;
    s_arrow(int(temp_n*dx), int(1*dy), int(temp_n*dx), int(1*dy + 172), 45);
    temp_n = 4;
    s_arrow(int(temp_n*dx), int(poisson_ubounds(temp_n)/temp_n * dy), int(temp_n*dx + 40), int(poisson_ubounds(temp_n)/temp_n * dy + 75), -45);
    temp_n = 25;
    s_arrow(int(temp_n*dx), int(poisson_lbounds(temp_n)/temp_n * dy), int(temp_n*dx - 40), int(poisson_lbounds(temp_n)/temp_n * dy + 156), 45);
    //
    textAlign(CENTER, BOTTOM);
    text("95% Confidence boundaries", 18*dx + x_origin, y_size - x_origin - 220);
    text("Average rate", 33*dx + x_origin, y_size - x_origin - 280);
  }
}

