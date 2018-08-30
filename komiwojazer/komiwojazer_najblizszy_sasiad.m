function [DlugoscNajkrotszejSciezki,NajkrotszaSciezka] = komiwojazer_najblizszy_sasiad(punkty)

%p1 = eval(wybor);

punkty = [1 2; 3 7; 3 5; 5 2; 9 1] % nasze punkty
N_punkty = size(punkty,1) %liczba punktow, tablica 1 komumnowa

dystans = pdist(punkty) %dystanst dystans miedzy parami, f-cja mathlaba
dystans = squareform(dystans) %przeksztalc do wektora N x 1

dystans(dystans==0) = realmax % przypisz duza liczbe / inf
DlugoscNajkrotszejSciezki = realmax % przypisz duza liczbe

for i = 1:N_punkty % dla kazdego punktu powtarzamy procedure

    PunktStartowy = i
    sciezka = PunktStartowy
    DystansPokonany = 0
    DystansNowy = dystans % macierz ortogonalna
    ObecnyPunkt = PunktStartowy
    
    for j = 1:N_punkty-1 % sprawdzamy dla wszystkich pozosta³ych
        [Najblizszy,NastepnyPunkt] = min(DystansNowy(:,ObecnyPunkt)) % najblizszy nieodwiedzony
        if (length(NastepnyPunkt) > 1) % dopoki mamy wybor
            NastepnyPunkt = NastepnyPunkt(1) % przechodzimy do niego
        end
        
        sciezka(end+1,1) = NastepnyPunkt %do sciezki przypisujemy NastepnyPunkt
        DystansPokonany = DystansPokonany + dystans(ObecnyPunkt,NastepnyPunkt) %zwiekszamy ca³kowity dystans
        DystansNowy(ObecnyPunkt,:) = realmax % zwiekszamy kolimne maciezy z obecnego punktu do inf
        ObecnyPunkt = NastepnyPunkt % przechodzimy do nastepnego 
    end

    sciezka(end+1,1) = PunktStartowy % bierzemy kolejny punkt startowy
    DystansPokonany = DystansPokonany + dystans(ObecnyPunkt,PunktStartowy) % +nowy
    
    if (DystansPokonany < DlugoscNajkrotszejSciezki) % jesli < niz najkrotsza dot¹d
        DlugoscNajkrotszejSciezki = DystansPokonany % zamieniamy
        NajkrotszaSciezka = sciezka  % aktualizujemy sciezke
    end   
end

figure % rysujemy wykres
x_min = min(punkty(:,1)) - 2;
x_max = max(punkty(:,1)) + 2;
y_min = min(punkty(:,2)) - 2;
y_max = max(punkty(:,2)) + 2;
plot(punkty(:,1),punkty(:,2),'bo');
axis([x_min x_max y_min y_max]);
axis equal;
grid on;
hold on;

xd=[];yd=[];

for i = 1:(N_punkty+1)
    xd(i)=punkty(NajkrotszaSciezka(i),1);
    yd(i)=punkty(NajkrotszaSciezka(i),2);
end

line(xd,yd);
title(['Dlugosc drogi = ', num2str(DlugoscNajkrotszejSciezki)]);
hold off;