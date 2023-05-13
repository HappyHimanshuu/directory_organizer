prompt :
	##use : make run
	##use : make run_del
run :
	mkdir -p ./tests/pond/
	rm -r ./tests/pond/
	cp -r ./.pond ./tests/
	mv ./tests/.pond ./tests/pond
	rm -r ./tests/redirect/
	mkdir -p ./tests/redirect
	bash script.sh

clean :
	rm -r ./tests/pond/
	rm -r ./tests/redirect/
	mkdir -p ./tests/redirect
	mkdir -p ./tests/pond

run_del :
	mkdir -p ./tests/pond/
	rm -r ./tests/pond/
	cp -r ./.pond ./tests/
	mv ./tests/.pond ./tests/pond
	rm -r ./tests/redirect/
	mkdir -p ./tests/redirect
	bash script.sh -d
create :
		mkdir -p ./tests/pond/
		rm -r ./tests/pond/
		cp -r ./.pond ./tests/
		mv ./tests/.pond ./tests/pond
		rm -r ./tests/redirect/
		mkdir -p ./tests/redirect
