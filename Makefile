clean:
	@rm -f *.rpm
rpm:
	rpmbuild -bb amengcdn-node.spec

.PHONY:rpm
