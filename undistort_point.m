function undistorted_point = undistort_point(pt,fx,fy,px,py,omega)
u_d = double(pt(1));  v_d = double(pt(2));
tan_omega_half_2 = 2 * tan(omega/2);

u_dn = (u_d - px) / fx;
v_dn = (v_d - py) / fy;

r_d = sqrt(u_dn.^2 + v_dn.^2);
r_u = tan(r_d * omega) / tan_omega_half_2;

u_n = r_u/r_d * u_dn;
v_n = r_u/r_d * v_dn;

u_x = fx*u_n + px;
v_x = fy*v_n + py;

undistorted_point = [u_x v_x]';
end
