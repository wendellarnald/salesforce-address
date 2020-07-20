/**
* @author wendellarnald
*/

public with sharing class AddressController {

	public AddressVO wrapper {
        get;
        set;
    }

    public void deserialize() {

    	String zipCode = Apexpages.currentPage().getParameters().get('zipCode');

    	if (!String.isEmpty(zipCode)) {
    		Http http = new Http();
	        HttpRequest request = new HttpRequest();
	        request.setEndPoint('https://viacep.com.br/ws/' + zipCode + '/json/');
	        request.setHeader('Content-type', 'application/json');
	        request.setMethod('GET');

	        HttpResponse response = http.send(request);

	        wrapper = (AddressVO) JSON.deserialize(response.getBody(), AddressVO.class);
    	}
    }

    public void saveAddress() {

    	if(wrapper != null) {
    		Account account = new Account();

    		account.Name = wrapper.cep;
    		account.ErpId__c = wrapper.cep + wrapper.logradouro;

    		account.ZipCode__c = wrapper.cep;
    		account.Address__c = wrapper.logradouro;
			account.Complement__c = wrapper.complemento;
			account.District__c = wrapper.bairro;
			account.Location__c = wrapper.localidade;
			account.State__c = wrapper.uf;
			account.Unit__c = wrapper.unidade;
			account.IBGE__c = wrapper.ibge;
			account.GIA__c = wrapper.gia;

    		upsert account;
            
    	}
    }
}