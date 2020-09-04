Print "Orif/Infobs - Jeu de Pong - Yannis Burkhalter"
Print "Jeu de Pong (1972)"
Print "----------------------------------------------------------------------"

nomainwin 'supprime la fen�tre habituelle

WindowWidth=649 '640 (taille de la fen�tre) + 9 (taille du bord)
WindowHeight=512 '480 (taille de la fen�tre) + 32 (taille du bord)
UpperLeftX=Int((DisplayWidth-WindowWidth)/2) 'Positionne la fen�tre au centre de l'�cran sur l'axe X (taille de l'�cran - taille de la fen�tre/2)
UpperLeftY=Int((DisplayHeight-WindowHeight)/2) 'Positionne la fen�tre au centre de l'�cran sur l'axe Y (taille de l'�cran - taille de la fen�tre/2)

'ouvre une fen�tre graphique nomm� PONG qui est accessible via #main
open "PONG" for graphics_nsb_nf as #main
#main,"trapclose [quit]" 'si la croix est cliqu�e, alors va � la ligne [quit]

'transf�re de toutes les images .bmp
loadbmp "bg","bg.bmp"
loadbmp "balle","balle.bmp"
loadbmp "barre","barre.bmp"
loadbmp "n1","1.bmp"
loadbmp "n2","2.bmp"
loadbmp "n3","3.bmp"
loadbmp "n4","4.bmp"
loadbmp "n5","5.bmp"
loadbmp "n6","6.bmp"
loadbmp "n7","7.bmp"
loadbmp "n8","8.bmp"
loadbmp "n9","9.bmp"
loadbmp "n0","0.bmp"

'cr�ation des sprites � partir des images
#main,"background bg" 'background d�finit le fond d'�cran
#main,"addsprite left barre" 'addsprite cr�e une sprite "left" � partir de l'image "barre"
#main,"addsprite right barre"
#main,"addsprite balle balle"
#main,"addsprite noGauche n0 n1 n2 n3 n4 n5 n6 n7 n8 n9" 'possibilit� de mettre plusieurs image pour une sprite
#main,"addsprite noDroite n0 n1 n2 n3 n4 n5 n6 n7 n8 n9"
#main,"cyclesprite noGauche 0" 'cyclesprite r�p�te en boucle les image d'une sprite (j'ai mis 0 car je ne veux pas que le score bouge tout le temps)
#main,"cyclesprite noDroite 0"

'Simples variables qui d�finirons les positions des objets (leurs noms n'a pas d'importance)
leftY=215
rightY=215
balleX=315
balleY=235

'Variable de d�placement de la balle et sa vitesse
deplacementHorizontal=-1
deplacementVertical=0
speed=4

'spritexy d�fini la position d'un objet en fonction de deux coordonn�es
#main,"spritexy noGauche 200 10"
#main,"spritexy noDroite 410 10"
#main,"drawsprites" 'drawsprites met � jour les emplacement des sprites dans la fen�tre

timer 10,[Boucle] 'Tous les 10 millisecondes, va � la ligne [Boucle]

#main,"setfocus" 'Se concentre sur les contr�les de la fen�tre #main
#main,"When mouseMove [control]" 'Chaque fois que la souris est boug�e, va � la ligne [control]
wait 'Bloque le programme pour ne pas ex�cuter les actions suivantes

[control]
leftY = MouseY-25 'leftY est la variable qui stock la position Y de la barre de gauche. Le -25 permet que la souris soit au centre de la barre et non en haut

wait

[Boucle]
#main,"spritecollides balle cote$" 'spritecollides v�rifies si "balle" touche un autre objet, si oui elle mais son nom dans la variable cote$

if cote$ = "left" then 'Si la balle touche le c�t� gauche alors...
    playwave "p1Snd.wav", async 'jouer un son. Si on ne met pas async, le jeu se stoppera et attendra la fin du son avant de continuer
    angle = (leftY-balleY+20)/5 'l'endroit o� la balle touche la barre est stock� dans la variable angle, elle peut valoir entre -5 et 5
    deplacementHorizontal=cos(-15*acs(-1)/180*angle) 'deplacementHorizontal = cos(-15� * angle). -15*acs(-1)/180 converti les degr�s en radians
    deplacementVertical=sin(-15*acs(-1)/180*angle)
    speed=4/deplacementHorizontal 'le temps que met la balle pour aller d'un bout � l'autre du jeu est toujours le m�me (4)
end if
if cote$ = "right" then 'M�me chose que left
    playwave "p1Snd.wav", async
    angle = (rightY-balleY+20)/5
    deplacementHorizontal=cos(-15*acs(-1)/180*angle)*-1 ' -1 permet de faire allez la balle dans l'autre sens
    deplacementVertical=sin(-15*acs(-1)/180*angle)
    speed=4/deplacementHorizontal*-1 ' il faut aussi mettre un -1 ici
end if
if balleY < 0 or balleY+10 > 480 then deplacementVertical = deplacementVertical*-1:playwave "p2Snd.wav", async 'si la balle touche le haut ou le bas, elle rebondit en �mettant un son

'Permet de faire que la balle se d�place
balleX = balleX+deplacementHorizontal*speed
balleY = balleY+deplacementVertical*speed

if balleX+10 < 0 then 'Si la balle passe derri�re le joueur de gauche, alors...
    playwave "misSnd.wav", async ' Jouer un son
    scoreP2 = scoreP2+1 'Augmente la valeur du score du joueur de droite
    #main,"cyclesprite noDroite -9 once" 'La sprite "noDroite" recule de 9 images, le once le bloque pour �viter qu'il ne tourne � l'infini
    balleX=315 'R�initialise les variables de la balle
    balleY=235
    deplacementHorizontal=1
    deplacementVertical=0
    speed=4
end if
if balleX > 640 then 'M�me chose mais avec le joueur de droite
    playwave "winSnd.wav", async
    scoreP1 = scoreP1+1
    #main,"cyclesprite noGauche -9 once"
    balleX=315
    balleY=235
    deplacementHorizontal=-1
    deplacementVertical=0
    speed=4
end if

if scoreP1 >= 10 then notice "Player 1 Wins" : gosub [quit] 'Si le score du joueur est �gal 10 alors il a gagn� et le jeu se ferme
if scoreP2 >= 10 then notice "Player 2 Wins" : gosub [quit] 'Si le score l'ordi est �gal 10 alors il a gagn� et le jeu se ferme

#main,"spritexy balle ";balleX;" ";balleY 'Red�fini l'emplacement de la balle

if balleY+5 > rightY+25 then hautBas = 1 'Si la balle est plus haute que l'ordi alors la variable hautBas = 1
if balleY+5 < rightY+25 then hautBas = -1 'Si non elle vaut -1

if hautBas = 1 and deplacementDroite < 5 then deplacementDroite = deplacementDroite + 1 'deplacementDroite est une variable qui peux valoir entre -5 et 5, c'est la vitesse de l'ordi
if hautBas = -1 and deplacementDroite > -5 then deplacementDroite = deplacementDroite - 1
rightY = rightY + deplacementDroite 'd�placement de la barre de droite
'(Ce n'ai pas comme �a que marche l'IA du jeu officiel mais je n'ai pas retrouv� les algorithmes originaux sur Internet)


#main,"spritexy left 20 ";leftY 'D�fini les emplacements des barres left et right, x ne change pas
#main,"spritexy right 610 ";rightY
#main,"drawsprites" 'drawsprites met � jour les emplacement des sprites dans la fen�tre
wait

[quit]
'unloadbmp permet de supprimer une image import�e
unloadbmp "bg"
unloadbmp "balle"
unloadbmp "barre"
unloadbmp "n1"
unloadbmp "n2"
unloadbmp "n3"
unloadbmp "n4"
unloadbmp "n5"
unloadbmp "n6"
unloadbmp "n7"
unloadbmp "n8"
unloadbmp "n9"
unloadbmp "n0"
close #main 'Ferme la fen�tre #main
end 'Fin du programme

