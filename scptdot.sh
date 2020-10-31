>carte.dot
echo "digraph cartographie {" >> carte.dot
cat carte*.rte >> carte.dot
echo } >> carte.dot
dot -Tpdf carte.dot > carte.pdf
