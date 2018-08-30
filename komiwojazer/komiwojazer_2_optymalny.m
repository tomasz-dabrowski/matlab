function [p,L] = komiwojazer_2_optymalny(X,m)

Punkty = [1 1; 1 7; 3 5; 5 2; 9 1];
[n,dim] = size(Punkty);
D = odleglosc(Punkty);

% sprawdz drugi argument
if nargin < 2 || isempty(m)
    m = 1;
elseif ~isscalar(m) || m < 1 || m > n || fix(m) < m
    mess = 'M musi byc liczba calkowita z przedzialu 1 do %d.';
    error('szukaj_tsp:second',mess,n)
end

s = randperm(n); % losowa permutacja

Lmin = inf; %poczatkowo dlugosci sciezki Lmin przypisujemy duza wartosc
for k = 1:m % najblizszy sasiad
	p = najblizszy(s(k),D);
    % Poprawa sciezki przez heurystyke 2-optymalna
	[p,L] = zamien2krawedzie(p,D);
    % Zachowaj najlepsza sciezke
	if L < Lmin
        Lmin = L;
        pmin = p;
	end
end

% Wyswietl
p = double(pmin);
L = Lmin;

% funkcje dodatkowe ------------------------

function D = odleglosc(Punkty)
% Liczymy odleglosc miedzy punktami

[n,dim] = size(Punkty);
D = zeros(n);
for j = 1:n
    for k = 1:dim
        v = Punkty(:,k) - Punkty(j,k);
        D(:,j) = D(:,j) + v.*v;
    end
end
D = sqrt(D);

function p = najblizszy(s,D)
% przesuwa do najblizszego sasiada z wierzcholka s

n = size(D,1);
p = zeros(1,n,'uint16');
p(1) = s;

for k = 2:n
    D(s,:) = inf;
    [junk,s] = min(D(:,s)); % ok
    p(k) = s;
end

%--------------------------------------------------------------------------
function [p,L] = zamien2krawedzie(p,D)
% Poprawiamy sciezke zamiana 2 krawedzi.
% Podstawowa operacja to zamiana krawedzi pary (ab,cd) na (ac,bd).
% Algorytm sprawdza wszystkie mozliwe pary krawedzi w danej turze
% i aplikujemy najlepsza zamiane. Procedura jest kontynuowana dopuki
% dlugosc sciezki sie zmniejsza. Wynik tej funkcji nazywamy 2-optymalnym.

n = numel(p);
zmin = -1;

% Interacja dopoki sciezka jest 2-optymalna
while zmin < 0

    zmin = 0;
    i = 0;
    b = p(n);

    % Petla po wszystkich parach krawedzi (ab,cd)
    while i < n-2
        a = b;
        i = i+1;
        b = p(i);
        Dab = D(a,b);
        j = i+1;
        d = p(j);
        while j < n
            c = d;
            j = j+1;
            d = p(j);
            z = (D(a,c) - D(c,d)) + D(b,d) - Dab;
            % Zachowaj najlepsza zamiane
            if z < zmin
                zmin = z;
                imin = i;
                jmin = j;
            end
        end
    end

    % Zatwierdz zamiane
    if zmin < 0
        p(imin:jmin-1) = p(jmin-1:-1:imin);
    end

end

% Dlugosc sciezki
q = double(p);
ind = sub2ind([n,n],q,[q(2:n),q(1)]);
L = sum(D(ind));