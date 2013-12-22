Noise
	Shader
		parent_type = /Noise/Modifier
		source_count_req = 1

		var
			light_x = 0
			light_y = 0
			light_z = 0

		proc
			setLightAngle(angle)
				light_x = cos(angle)
				light_y = sin(angle)
				light_z = 1

				normalizeLightVector()

			normalizeLightVector()
				. = sqrt(light_x * light_x + light_y * light_y + light_z * light_z)

				light_x /= .
				light_y /= .
				light_z /= .

		get2(x, y)
			var
				list/normal = source.get2(x, y)
				dot = light_x * normal[1] + light_y * normal[2] + 1

			return dot

		get3(x, y, z)
			var
				list/normal = source.get3(x, y, z)
				dot = light_x * normal[1] + light_y * normal[2] + light_z * normal[3]

			return dot