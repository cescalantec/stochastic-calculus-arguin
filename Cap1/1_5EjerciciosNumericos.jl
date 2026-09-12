# Libro: A First Course in Stocastic Calculus - Louis-Pierre Arguin

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
          normalize = :probability,
          title = "Con histogram de StatsPlots", 
          xlabel = "x", 
          ylabel = "Frecuencia relativa", 
          legend = false,
          color = :lightgray)

#=
1.1(c) Graficar la función de distribución (fd)
=#
# Forma 1. Con Plots. Usamos los resultados que nos sirvan
a_acumulado = cumsum(a)

plot(marca_clase_j, a_acumulado,
    title = "Función de distribución manual de la muestra aleatoria",
    xlabel = "x",
    ylabel = "Frec. relativa acum.",
    legend = false)

# Forma 2. Con StatsPlos. Histograma.

ecdfplot(x, 
            bins = m, 
            title = "Función de distrib. con StatsPlots", 
            xlabel = "x", 
            ylabel = "Frec. relativa acum.", 
            legend = false,
            color = :gray)

#=
1.1(d) Repetir (b) y (c) para el cuadrado de los números aleatorios

Hacemos estas gráficas solo usando StatsPlots
=#

x2 = x.^2

histogram(x2, 
        normalize = :probability,
        bins = m, 
        title = "Histograma de x^2", 
        xlabel = "x", 
        ylabel = "Frecuencia relativa", 
        legend = false,
        color = :lightgray)

ecdfplot(x2, 
        bins = m, 
        title = "Función de distrib. de x^2", 
        xlabel = "x", 
        ylabel = "Frec. relativa acum.", 
        legend = false,
        color = :gray)

