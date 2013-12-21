Noise
	Generator
		Cellular
			var
				distance_function = DISTANCE_EUCLIDEAN
				__distance_function = __DISTANCE_EUCLIDEAN

				coeff_1 = 1
				coeff_2 = 0
				coeff_3 = 0
				coeff_4 = 0

				Noise/Generator/Simplex/simplex = new

			proc
				setDistanceFunction(_distance_function = DISTANCE_EUCLIDEAN)
					_distance_function = round(_distance_function)
					ASSERT(_distance_function > 0 && _distance_function < 4)

					distance_function = _distance_function

					switch(distance_function)
						if(DISTANCE_EUCLIDEAN) __distance_function = __DISTANCE_EUCLIDEAN
						if(DISTANCE_MANHATTAN) __distance_function = __DISTANCE_MANHATTAN
						if(DISTANCE_CHEBYSHEV) __distance_function = __DISTANCE_CHEBYSHEV

				setCoefficients(a, b, c, d)
					coeff_1 = a
					coeff_2 = b
					coeff_3 = c
					coeff_4 = d

				setCoefficient1(a)
					coeff_1 = a

				setCoefficient2(b)
					coeff_2 = b

				setCoefficient3(c)
					coeff_3 = c

				setCoefficient4(d)
					coeff_4 = d

				getDistanceFunction()
					return distance_function

				getCoefficient1()
					return coeff_1

				getCoefficient2()
					return coeff_2

				getCoefficient3()
					return coeff_3

				getCoefficient4()
					return coeff_4