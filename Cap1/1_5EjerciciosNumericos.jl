# Propuesta de solución de algunos de los Ejercicios de proyectos numéricos, sección 1.5

#=
1.1. Distribuciones como histogramas. El objetivo es reproducir la Figura 1.1.
1.1(a) Muestra de N=10_000 números aleatorios en [0,1].
=#

N = 10_000
x = rand(N)

#=
1.1(b) Graficar la función de densidad de probabilidad (fdp). Dividimos el intervalo [0, 1] en m = 50 partes B_1, B_2, ...,B_50 de igual longitud 1/50. Graficamos el histograma de los N números aleatorios obtenidos en 1.1(a) para las m partes del intervalo [0, 1] donde el valor de la parte j es

#{i ≤ N: X_i ∈ B_j} / N
=#

m = 50
B = 0:(1/m):1
length(B)

# Conteo de números aleatorios x en cada uno de los 50 subintervalos de [0, 1] determinados por B.
# Guardamos en y el número de elementos de x en cada subintervalo.
y = zeros(Int, m)
for j in eachindex(y)
    x_j = @. x[B[j] ≤ x < B[j+1]] # Elementos x en el intervalo j.
    y[j] = length(x_j)
end

@assert sum(y) == N

a = y / N

# Obtenemos en histograma de dos formas:

# Forma 1. Con Plots. Diagrama de barras, usando a.
marca_clase_j = [(B[j] + B[j+1]) / 2 for j in eachindex(y)]

using Plots

bar(marca_clase_j, a,
    title = "Histograma manual desde muestra aleatoria",
    xlabel = "x",
    ylabel = "Frecuencia relativa",
    legend = false,
    color = :cyan)

# Forma 2. Con StatsPlos. Histograma.
using StatsPlots

histogram(x, 
          bins = m, 
          title = "Con histogram de StatsPlots", 
          xlabel = "x", 
          ylabel = "Frecuencia relativa", 
          legend = false,
          color = :lightgray)

