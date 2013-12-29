Noise
	Transformer
		RotatePoint
			source_count_req = 1

			var
				x1_matrix
				y1_matrix
				z1_matrix
				x2_matrix
				y2_matrix
				z2_matrix
				x3_matrix
				y3_matrix
				z3_matrix

				x_angle
				y_angle
				z_angle

			get3(x, y, z)
				x += seed
				y += seed
				z += seed

				return source.get3((x1_matrix * x) + (y1_matrix * y) + (z1_matrix * z), (x2_matrix * x) + (y2_matrix * y) + (z2_matrix * z), (x3_matrix * x) + (y3_matrix * y) + (z3_matrix * z))

			get2(x, y)
				x += seed
				y += seed

				return source.get2((x1_matrix * x) + (y1_matrix * y), (x2_matrix * x) + (y2_matrix * y))

			proc
				setAngles(_x_angle = 0, _y_angle = 0, _z_angle = 0)
					x_angle = _x_angle
					y_angle = _y_angle
					z_angle = _z_angle

					var
						x_cos = cos(x_angle)
						y_cos = cos(y_angle)
						z_cos = cos(z_angle)
						x_sin = sin(x_angle)
						y_sin = sin(y_angle)
						z_sin = sin(z_angle)

					x1_matrix = y_sin * x_sin * z_sin + y_cos * z_cos
					y1_matrix = x_cos * z_sin
					z1_matrix = y_sin * z_cos - y_cos * x_sin * z_sin
					x2_matrix = y_sin * x_sin * z_cos - y_cos * z_sin
					y2_matrix = x_cos * z_cos
					z2_matrix = -y_cos * x_sin * z_cos - y_sin * z_sin
					x3_matrix = -y_sin * x_cos
					y3_matrix = x_sin
					z3_matrix = y_cos * x_cos

				setXAngle(_x_angle = 0)
					setAngles(_x_angle, y_angle, z_angle)

				setYAngle(_y_angle = 0)
					setAngles(x_angle, _y_angle, z_angle)

				setZAngle(_z_angle = 0)
					setAngles(x_angle, y_angle, _z_angle)

				getXAngle()
					return x_angle

				getYAngle()
					return y_angle

				getZAngle()
					return z_angle