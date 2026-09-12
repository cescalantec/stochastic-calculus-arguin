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

#=
===============================================================================================

1.2 La ley de los grandes números. Este proyecto tiene el objetivo de familiarizarnos con la ley de los grandes números, Ec. (1.5). Experimentamos con variables aleatorias exponenciales, pero serviviría cualquier otra distribución con media finita.

1.2(a) La ley fuerte. Obtenemos una muestra de N números aleatorios con distribución exponencial con parámetro 1. Graficamos x = 1:N vs. y_m = media(x) para N = 1, 2, ..., 10_000. Observamos.

Solución. Usaremos el paquete Distributions.jl

En el libro la densidad exponencial es f(x) = λexp(-λx) y en el paquete Distributions es f(x) = (1/θ)exp(-x/θ), lo que implica que θ = 1/λ, que para λ = 1, θ = 1, pero que hay que tener en cuenta en general. Para calcular la media muestral usamos el paquete StatsBase.

=#

using Distributions

N = 10_000

λ = 1
X = Exponential(1/λ)

# Muestra aleatoria
x_aleat = rand(X, N)

# Vector de medias de tamaño creciente desde 1 hasta N

medias = [mean(x_aleat[1:j]) for j in 1:N]

plot(1:N, medias,
    legend=false,
    color=:red)

#=
1.2(b) La ley débil. 

Solución
=#

N = 10_000

media_empirica_exp(n::Int64) = mean(rand(X, n))

muestras_n_100 = [media_empirica_exp(100) for _ in 1:N]
muestras_n_10000 = [media_empirica_exp(10_000) for _ in 1:N]

media_min = minimum(vcat(muestras_n_100, muestras_n_10000))
media_max = maximum(vcat(muestras_n_100, muestras_n_10000))

h1 = histogram(muestras_n_100,
          normalize = :pdf,
          xlims = [media_min, media_max],
          title = "Histograma. 10_000 medias de tamaño 100 c/u", 
          xlabel = "x", 
          ylabel = "Densidad", 
          legend = false,
          color = :lightgray,
          linecolor = :transparent)
plot!(h1, Normal(1, 1/sqrt(100)), linewidth=2, color=:black)

h2 = histogram(muestras_n_10000,
          normalize = :pdf,
          xlims = [media_min, media_max],
          title = "Hist. 10_000 medias de tamaño 10_000 c/u", 
          xlabel = "x", 
          ylabel = "Densidad", 
          legend = false,
          color = :pink,
          linecolor = :transparent)
plot!(h2, Normal(1, 1/sqrt(10_000)), linewidth=2, color=:black)

plot(h1, h2, layout = (2,1), size = (900, 800))

# Funciones de distribución
cdf1 = ecdfplot(muestras_n_100,
          xlims = [media_min, media_max],
          title = "CDF. 10_000 medias de tamaño 100 c/u",
          xlabel = "x",
          ylabel = "F(x)",
          legend = false,
          color = :black)

cdf2 = ecdfplot(muestras_n_10000,
          xlims = [media_min, media_max],
          title = "CDF. 10_000 medias de tamaño 10_000 c/u",
          xlabel = "x",
          ylabel = "F(x)",
          legend = false,
          color = :black)

plot(cdf1, cdf2, layout = (2,1), size = (900, 800))

#=
* 1.2(a) Ley Fuerte - Trayectoria
Se nota que la media empírica presenta una alta volatilidad para valores pequeños de $N$. Conforme $N$ se acerca a $10,000$, las fluctuaciones menguan y la trayectoria de la sucesión de medias converge de forma estable al valor esperado teórico $\mu = 1$.

* 1.2(b) Ley Débil - PDF y CDF
Se nota que al incrementar la muestra de $N = 100$ a $N = 10_000$, la varianza de la distribución de la media muestral colapsa hacia cero.

* En los histogramas (Densidad): La distribución para $N = 100$ muestra una dispersión acampanada con un rango de desviación amplio. Para $N = 10_000$, la masa de densidad se comprime formando un pico agudo y angosto exactamente sobre el valor $1$.

* En las distribuciones acumuladas (CDF): La curva para $N = 100$ exhibe un crecimiento gradual (forma sigmoide), lo que indica que la probabilidad se acumula a lo largo de un intervalo ancho de valores. Para $N = 10_000$, la curva se transforma en una función escalón que salta verticalmente de $0$ a $1$ en la coordenada $x = 1$.

=#