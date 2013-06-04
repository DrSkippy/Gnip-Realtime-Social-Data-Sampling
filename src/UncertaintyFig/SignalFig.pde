class figure_sig extends figure_un {

  float pre_dy;
  float sig_par = 0.8;

  figure_sig(String _name, int _n, float _dy) {
    super(_name, _n); 
    pre_dy = _dy;
  } 

  float sigmoid(float t, float dt, float dr) {
    // increases from 1 to 1 + dr
    return 1. + dr/(1. + exp(sig_par*(dt-t)));
  }

  void conf_curve(int x_origin, int x_pixels, int y_pixels) {
    float x;
    float y;
    float yu;
    float yl;
    // steps in increase
    float dt = 9;
    // signal increasees by...
    float dr = 1.5;
    //
    // settings
    strokeWeight(1);
    float dx = x_pixels/(2.*dt);
    if (pre_dy == 0) {
      dy = y_pixels/poisson_ubounds(int(n*(1. + dr)));
    } else {
      dy = pre_dy;
    }
    // 
    // first point
    float x_last = 0;
    float rate = n;
    float y_last = rate * dy;
    float yu_last = poisson_ubounds(int(rate)) * dy;
    float yl_last = poisson_lbounds(int(rate)) * dy;
    // The final value of the rate
    stroke(marker_color);
    //line(x_origin, y_size - (x_origin + int(n*(1. + dr)*dy)), x_origin + dt*dx, y_size - (x_origin + int(n*(1. + dr)*dy)));
    arrow(x_origin + 50, x_origin + int(n*(1. + dr)*dy), int(x_origin + dt*dx/2), x_origin + int(n*(1. + dr)*dy));
    //stroke(point_color);
    //point(x_origin + x_last, y_size - (x_origin + yu_last));
    //point(x_origin + x_last, y_size - (x_origin + yl_last));
    //point(x_origin + x_last, y_size - (x_origin + y_last));
    //
    for (int i=1;i<=2*dt;i++) {
      x = i * dx;
      rate = n * sigmoid(i, dt, dr);
      yu = poisson_ubounds(int(rate)) * dy;
      yl = poisson_lbounds(int(rate)) * dy;
      y = rate * dy;
      stroke(line_color);
      line(x_origin + x_last, y_size - (x_origin + yu_last), x_origin + x, y_size - (x_origin + yu));
      line(x_origin + x_last, y_size - (x_origin + yl_last), x_origin + x, y_size - (x_origin + yl));
      stroke(baseline_color);
      line(x_origin + x_last, y_size - (x_origin + y_last), x_origin + x, y_size - (x_origin + y));
      //stroke(point_color);
      //point(x_origin + x, y_size - (x_origin + yu));
      //point(x_origin + x, y_size - (x_origin + yl));
      //point(x_origin + x, y_size - (x_origin + y));
      x_last = x;
      yu_last = yu;
      yl_last = yl;
      y_last = y;
    }
  }
}

