Noise
	Generator
		Fractal
			var
				list/weights
				octaves = 6
				frequency = 1
				amplitude = 1
				lacunarity = 2
				gain = 0.65
				offset = 0
				h = 0

			source_count_req = 1

			New(Noise/_source)
				if(_source) addSource(_source)
				else addSource(new/Noise/Generator/Simplex)

				calculateWeights()

			proc
				setOctaves(_octaves = 6)
					octaves = _octaves
					calculateWeights()

				setFrequency(_frequency = 1)
					frequency = _frequency

				setAmplitude(_amplitude = 1)
					amplitude = _amplitude

				setLacunarity(_lacunarity = 2)
					lacunarity = _lacunarity

				setGain(_gain = 0)
					gain = _gain

				setOffset(_offset = 0)
					offset = _offset

				setH(_h = 1)
					h = _h

				calculateWeights()
					weights = list()

					var/freq = frequency
					for(var/i = 1, i <= octaves, i ++)
						weights += freq ** -h
						freq *= lacunarity

				getOctaves()
					return octaves

				getFrequency()
					return frequency

				getAmplitude()
					return amplitude

				getLacunarity()
					return lacunarity

				getGain()
					return gain

				getOffset()
					return offset

				getH()
					return h