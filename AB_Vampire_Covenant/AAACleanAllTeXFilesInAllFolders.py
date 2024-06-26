
import os, sys

def removenewrule(filename):
	f = open(filename, 'r', encoding='utf-8')
	fdest = open("tempo_cleantexfile.tex", 'w', encoding='utf-8')
	
	# Find a first \newrule{
	# Find the corresponding closing } ; careful, there might be other opening {, we need to remove the good corresponding }
	# Remove the \newrule{ and the corresponding }
	# Start again until there is no more \newrule{
	wholetext = f.read()
	while wholetext.find("\\newrule{") != -1 :
		index_newrule = wholetext.find("\\newrule{")
		index_closing_bracket = -1
		index_other_opening_bracket = -1
		good_closing_bracket_found = 0
		while good_closing_bracket_found == 0 :
			if index_closing_bracket+1 > len(wholetext) or index_other_opening_bracket+1 > len(wholetext) : # checking if we haven't reached the end of the text
				sys.exit("No closing bracket was found for a \\newrule{ in " + filename + ".")
			# Looking for the new indexes of the next opening and closing brackets, starting first at the end of \newrule{ (i.e. index_newrule+9) and then at the last opening/closing bracket found, if there was nested brackets
			index_closing_bracket = wholetext.find("}", max(index_newrule+9,index_closing_bracket+1))
			index_other_opening_bracket = wholetext.find("{", max(index_newrule+9,index_other_opening_bracket+1))
			if (index_other_opening_bracket == -1 or index_other_opening_bracket > index_closing_bracket) :
				if index_closing_bracket == -1 :
					sys.exit("No closing bracket was found for a \\newrule{ in " + filename + ".")
				else : # Else we found the closing bracket, the loop will end
					good_closing_bracket_found = 1
			# Else there are nested brackets, we need to search again, starting at index_other_opening_bracket +1 for the opening bracket search, and at index_closing_bracket +1 for the closing bracket search.
		# Now we can remove the "\\newrule{" and the corresponding closing bracket from the text
		wholetext = wholetext[:index_newrule] + wholetext[index_newrule+9:index_closing_bracket] + wholetext[index_closing_bracket+1:]
	# Now the text is cleaned. We can copy it to the new file
	fdest.write(wholetext)
	# Now the file has been dealt with, we just need to delete the old file and rename the tempo file
	f.close()
	fdest.close()
	os.remove(filename)
	os.rename("tempo_cleantexfile.tex",filename)
	return

def removerewordedrule(filename):
	f = open(filename, 'r', encoding='utf-8')
	fdest = open("tempo_cleantexfile.tex", 'w', encoding='utf-8')
	
	# Find a first \rewordedrule{
	# Find the corresponding closing } ; careful, there might be other opening {, we need to remove the good corresponding }
	# Remove the \rewordedrule{ and the corresponding }
	# Start again until there is no more \rewordedrule{
	wholetext = f.read()
	while wholetext.find("\\rewordedrule{") != -1 :
		index_newrule = wholetext.find("\\rewordedrule{")
		index_closing_bracket = -1
		index_other_opening_bracket = -1
		good_closing_bracket_found = 0
		while good_closing_bracket_found == 0 :
			if index_closing_bracket+1 > len(wholetext) or index_other_opening_bracket+1 > len(wholetext) : # checking if we haven't reached the end of the text
				sys.exit("No closing bracket was found for a \\rewordedrule{ in " + filename + ".")
			# Looking for the new indexes of the next opening and closing brackets, starting first at the end of \newrule{ (i.e. index_newrule+9) and then at the last opening/closing bracket found, if there was nested brackets
			index_closing_bracket = wholetext.find("}", max(index_newrule+14,index_closing_bracket+1))
			index_other_opening_bracket = wholetext.find("{", max(index_newrule+14,index_other_opening_bracket+1))
			if (index_other_opening_bracket == -1 or index_other_opening_bracket > index_closing_bracket) :
				if index_closing_bracket == -1 :
					sys.exit("No closing bracket was found for a \\rewordedrule{ in " + filename + ".")
				else : # Else we found the closing bracket, the loop will end
					good_closing_bracket_found = 1
			# Else there are nested brackets, we need to search again, starting at index_other_opening_bracket +1 for the opening bracket search, and at index_closing_bracket +1 for the closing bracket search.
		# Now we can remove the "\\newrule{" and the corresponding closing bracket from the text
		wholetext = wholetext[:index_newrule] + wholetext[index_newrule+14:index_closing_bracket] + wholetext[index_closing_bracket+1:]
	# Now the text is cleaned. We can copy it to the new file
	fdest.write(wholetext)
	# Now the file has been dealt with, we just need to delete the old file and rename the tempo file
	f.close()
	fdest.close()
	os.remove(filename)
	os.rename("tempo_cleantexfile.tex",filename)
	return

def removeremovedrule(filename):
	f = open(filename, 'r', encoding='utf-8')
	fdest = open("tempo_cleantexfile.tex", 'w', encoding='utf-8')

	# Find a first \removedrule{
	# Find the corresponding closing } ; careful, there might be other opening {, we need to remove the good corresponding }
	# Remove the \removedrule{, the closing } and everything between
	# Start again until there is no more \removedrule{

	wholetext = f.read()
		
	while wholetext.find("\\removedrule{") != -1 :
		index_removedrule = wholetext.find("\\removedrule{")
		index_closing_bracket = -1
		index_other_opening_bracket = -1
		good_closing_bracket_found = 0
		while good_closing_bracket_found == 0 :
			if index_closing_bracket+1 > len(wholetext) or index_other_opening_bracket+1 > len(wholetext) : # checking if we haven't reached the end of the text
				sys.exit("No closing bracket was found for a \\removedrule{ in " + filename + ".")
			# Looking for the new indexes of the next opening and closing brackets, starting first at the end of \removedrule{ (i.e. index_removedrule+13) and then at the last opening/closing bracket found, if there was nested brackets
			index_closing_bracket = wholetext.find("}", max(index_removedrule+13,index_closing_bracket+1))
			index_other_opening_bracket = wholetext.find("{", max(index_removedrule+13,index_other_opening_bracket+1))
			if (index_other_opening_bracket == -1 or index_other_opening_bracket > index_closing_bracket) :
				if index_closing_bracket == -1 :
					sys.exit("No closing bracket was found for a \\removedrule{ in " + filename + ".")
				else : # Else we found the closing bracket, the loop will end
					good_closing_bracket_found = 1
			# Else there are nested brackets, we need to search again, starting at index_other_opening_bracket +1 for the opening bracket search, and at index_closing_bracket +1 for the closing bracket search.
		# Now we can remove the "\\removedrule{", the corresponding closing bracket, and everything between from the text
		wholetext = wholetext[:index_removedrule] + wholetext[index_closing_bracket+1:]
	# Now the text is cleaned. We can copy it to the new file
	fdest.write(wholetext)
	# Now the file has been dealt with, we just need to delete the old file and rename the tempo file
	f.close()
	fdest.close()
	os.remove(filename)
	os.rename("tempo_cleantexfile.tex",filename)
	return

def removeremovedreworded(filename):
	f = open(filename, 'r', encoding='utf-8')
	fdest = open("tempo_cleantexfile.tex", 'w', encoding='utf-8')

	# Find a first \removedreworded{
	# Find the corresponding closing } ; careful, there might be other opening {, we need to remove the good corresponding }
	# Remove the \removedreworded{, the closing } and everything between
	# Start again until there is no more \removedreworded{

	wholetext = f.read()
		
	while wholetext.find("\\removedreworded{") != -1 :
		index_removedrule = wholetext.find("\\removedreworded{")
		index_closing_bracket = -1
		index_other_opening_bracket = -1
		good_closing_bracket_found = 0
		while good_closing_bracket_found == 0 :
			if index_closing_bracket+1 > len(wholetext) or index_other_opening_bracket+1 > len(wholetext) : # checking if we haven't reached the end of the text
				sys.exit("No closing bracket was found for a \\removedreworded{ in " + filename + ".")
			# Looking for the new indexes of the next opening and closing brackets, starting first at the end of \removedreworded{ (i.e. index_removedrule+17) and then at the last opening/closing bracket found, if there was nested brackets
			index_closing_bracket = wholetext.find("}", max(index_removedrule+17,index_closing_bracket+1))
			index_other_opening_bracket = wholetext.find("{", max(index_removedrule+17,index_other_opening_bracket+1))
			if (index_other_opening_bracket == -1 or index_other_opening_bracket > index_closing_bracket) :
				if index_closing_bracket == -1 :
					sys.exit("No closing bracket was found for a \\removedreworded{ in " + filename + ".")
				else : # Else we found the closing bracket, the loop will end
					good_closing_bracket_found = 1
			# Else there are nested brackets, we need to search again, starting at index_other_opening_bracket +1 for the opening bracket search, and at index_closing_bracket +1 for the closing bracket search.
		# Now we can remove the "\\removedrule{", the corresponding closing bracket, and everything between from the text
		wholetext = wholetext[:index_removedrule] + wholetext[index_closing_bracket+1:]
	# Now the text is cleaned. We can copy it to the new file
	fdest.write(wholetext)
	# Now the file has been dealt with, we just need to delete the old file and rename the tempo file
	f.close()
	fdest.close()
	os.remove(filename)
	os.rename("tempo_cleantexfile.tex",filename)
	return

def explore_folder(path):
    for e in os.listdir(path):
        element_path = os.path.join(path, e)
        if os.path.isdir(element_path): explore_folder(element_path)
        elif e.endswith('.tex'): file_list.append(element_path)
file_list = []
explore_folder(os.getcwd())

if len(file_list) == 0 :
	sys.exit("No .tex files found in this folder.")

for filename in file_list :
	removenewrule(filename)
	removeremovedrule(filename)
	removerewordedrule(filename)
	removeremovedreworded(filename)

sys.exit(0)
