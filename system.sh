#!/bin/bash
FILE='Databses_names'
select n in "Create Database" "List Database" "Connect to Database" "Drop Database"
do 
case $n in
	"Create Database") echo "Enter DatabaseName" 
	       	read name
		result=$(awk -v patern=$name '$1 == patern {print $1}' .Databases_names)
		if [[ "$result" ]]; then
			echo "Database is already exists"
		else
			mkdir $name && touch $name/Table_names
			echo $name >>  .Databases_names
		fi
		;;
	"List Database") ls 
	       	;;

	"Connect to Database") 	echo "Enter DatabaseName" && read Db_name 
			cd ./$Db_name
			x=`pwd` 
			echo $x
			select choise in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table"
			do
			case $choise in
				"Create Table")  echo "Enter Table Name" 
				       	read Table_name
						if [ $Table_name == "$(awk '{print $0}' .Table_names)" ]
						then
							echo "This Table already exist, change Table name"
						else
							touch $Table_name
							echo "Etner The Primary key"
							read prim_key
							echo "$Table_name	$prim_key" >> ./.Table_names
							echo "Enter Number of Columns" && read num_colum
							

							k=0
							while [ $num_colum -gt 0 ]
							do
								echo " what coulm $(($k+1)) datatype is ? such as [ int ,string ]"
								read datatype
								echo "enter coulm $(($k+1))"
								read -p "Enter value: " datatype

								if [[ $datatype =~ ^[+-]?[0-9]+$ ]]; then
									input="integer"
								elif [[ $datatype =~ ^[+-]?[0-9]*\.[0-9]+$ ]]; then
							        	input="Float"
								else
									 input="string"
								fi
								read x
								if [[ -z "$x" || $datatype != $var ]]
								then
									echo "please ReEnter this cell, Enter $datatype value!"
									break
								else
									array[$k]=$x
									k=$(($k+1))
									if [ $k -eq $num_colum ]
									then
										break
								fi	fi
							done
							echo ${array[@]} > $Table_name
	

						fi
					;;
				"List Tables") ls .
					;;
				"Drop Table") echo "Enter Table Name" && read d_table 
						if [ $d_table == "$(awk '{print $0}' .Table_names)" ]
						then
					 		rm $d_table
						else
							echo "This Table does not  exist in Database"
						fi
					;;
				"Insert into Table") echo "Enter Table Name" && read Table
					if [ $Table == "$(awk '{print $0}' .Table_names)" ]
					then
						result=$(awk '{print NF}' $Table|sort -nu| tail -n 1)    
						#result = $(awk -F BEGIN'{print $NF}' $Table)
					  	#echo $result
						colums[0]=0
						k=0
						for (( i=1; i<=$result; i++ ))
						do
							coulm=$(head -n 1 $Table|cut -d" " -f$i)
							echo "enter $coulm"
							read var
							colums[$k]=$var
							k=$(($k+1))
						done
						echo ${colums[@]} >> $Table
					else
						echo "This Table does not exists"


					fi
					;;
				"Select From Table")
					;;
				"Delete From Table") echo "Enter Table Name" && read Table_name
					if [ $Table_name == "$(awk '{print $0}' .Table_names)" ]
					then

					else
						echo "This Table does not exists"
					fi
					;;
				"Update Table")
					;;
			esac
			
			done
		;;

	"Drop Database") read -p "Enter Database Name"  name
	        exist=$(awk -F" " -v patern=$name '$0 == patern {print $0}' .Databases_names)
		if [[ "$exist" ]]; then
			rm -r $name
		else
			echo "This Database Does not exist"
		fi
	;;
       *) echo "This Option does not exist,please enter an correct option"
	       ;;
esac
done
