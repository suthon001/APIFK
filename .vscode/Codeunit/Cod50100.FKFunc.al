codeunit 50030 "FK Func"
{
    procedure CreateCustomer(customerlists: BigText): Text;
    var
        ltJsonObject, ltJsonObject2 : JsonObject;
        ltJsonToken, ltJsonToken2 : JsonToken;
        ltJsonArray: JsonArray;
        ltmyLoop: Integer;
        JSONManagement: Codeunit "JSON Management";
        CustomerJsonObject: text;
    begin
        ltJsonToken.ReadFrom(Format(customerlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            ERROR(format(ltJsonObject2));
        end;
    end;

    local procedure SelectJsonTokenText(JsonObject: JsonObject; Path: text): text;
    var
        ltJsonToken: JsonToken;
        lJObjProduct: JsonObject;
        lJArrSku: JsonArray;
        ImageText: Text;
    begin
        if not JsonObject.SelectToken(Path, ltJsonToken) then
            exit('');
        if ltJsonToken.AsValue.IsNull then
            exit('');
        exit(ltJsonToken.asvalue.astext());
    end;
}
