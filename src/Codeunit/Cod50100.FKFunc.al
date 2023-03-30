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
        PageControl: Record "Page Control Field";
    begin
        ltJsonToken.ReadFrom(Format(customerlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            //ERROR(SelectJsonTokenText(ltJsonObject2, '$.no'));
        end;
    end;

    procedure ExportJsonFormat(pPageNO: Integer; pTableID: Integer)
    var
        PageControl: Record "Page Control Field";
        ltField: Record Field;
        ltJsonObject: JsonObject;
        ltJsonArray: JsonArray;
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
    begin
        CLEAR(ltJsonArray);
        CLEAR(ltJsonObject);
        ltRecordRef.Open(pTableID);
        ltRecordRef.FindFirst();
        if ltRecordRef.FindFirst() then begin
            PageControl.reset();
            PageControl.SetRange(PageNo, pPageNO);
            PageControl.SetRange(Visible, 'TRUE');
            if PageControl.FindSet() then begin
                repeat
                    ltField.GET(PageControl.TableNo, PageControl.FieldNo);
                    ltFieldRef := ltRecordRef.Field(ltField."No.");
                    ltJsonObject.Add(format(ltField."No."), format(ltFieldRef.Value));
                until PageControl.Next() = 0;
                ltJsonArray.Add(ltJsonObject);
            end;
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
