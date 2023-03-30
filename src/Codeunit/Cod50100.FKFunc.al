codeunit 50030 "FK Func"
{
    procedure CreateCustomer(customerlists: BigText): Text;
    var
        ltJsonObject, ltJsonObjectDetail, ltJsonObject2, JsonObjectSelect : JsonObject;
        ltJsonToken, ltJsonToken2, ltJsonTokenDetail : JsonToken;
        ltJsonArray, ltJsonArrayDetail : JsonArray;
        ltmyLoop: Integer;
        JSONManagement: Codeunit "JSON Management";
        CustomerJsonObject: text;
        PageControl: Record "Page Control Field";
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltField: Record Field;
    begin
        ltJsonToken.ReadFrom(Format(customerlists).Replace('\', ''));
        ltJsonArray := ltJsonToken.AsArray();
        foreach ltJsonToken2 in ltJsonArray do begin
            ltJsonObject2 := ltJsonToken2.AsObject();
            ltJsonObject2.SelectToken('$.detail', ltJsonToken2);
            ltJsonArrayDetail := ltJsonToken2.AsArray();
            foreach ltJsonTokenDetail in ltJsonArrayDetail do begin
                ltJsonObjectDetail := ltJsonTokenDetail.AsObject();
                ERROR(SelectJsonTokenText(ltJsonObjectDetail, '$.nos'));
            end;
        end;
    end;

    procedure ExportJsonFormatPurchase(pPageNO: Integer; pPageNOSubform: Integer; pDocumentType: Enum "Purchase Document Type"; pApiName: Text)
    var
        PageControl, PageControlDetail : Record "Page Control Field";
        ReservationEntry: Record "Reservation Entry";
        ltField: Record Field;
        ltJsonObject, ltResult, ltJsonObjectbuill, ltJsonObjectbuillReserve, ltJsonObjectReserve : JsonObject;
        ltJsonArray, ltJsonArraybuill, ltJsonArrayReserve : JsonArray;
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltText: Text;
        tempBlob: Codeunit "Temp Blob";
        ltOutStr: OutStream;
        ltInstr: InStream;
        ltFileName: Text;
        ValueDecimal: Decimal;
        ValueInteger, ltLineNo : Integer;
        documentNo: Code[20];
    begin
        CLEAR(ltFieldRef);
        CLEAR(ltJsonObject);
        CLEAR(ltJsonObjectbuill);
        CLEAR(ltJsonArrayReserve);
        CLEAR(ltJsonObjectReserve);
        ltRecordRef.Open(38);
        ltFieldRef := ltRecordRef.FieldIndex(1);
        ltFieldRef.SetRange(pDocumentType);
        if ltRecordRef.FindFirst() then begin
            ltFieldRef := ltRecordRef.FieldIndex(2);
            documentNo := format(ltFieldRef.Value);
            PageControl.reset();
            PageControl.SetCurrentKey(FieldNo);
            PageControl.SetRange(PageNo, pPageNO);
            if PageControl.FindSet() then begin
                repeat
                    if ltRecordRef.FieldExist(PageControl.FieldNo) then begin
                        ltField.GET(PageControl.TableNo, PageControl.FieldNo);
                        if (ltField.Class = ltField.Class::Normal) and (ltField.Type <> ltField.Type::BLOB) then begin
                            ltFieldRef := ltRecordRef.Field(ltField."No.");
                            if ltField.Type in [ltField.Type::Decimal, ltField.Type::Integer] then begin
                                if ltField.Type = ltField.Type::Integer then begin
                                    Evaluate(ValueInteger, format(ltFieldRef.Value));
                                    if ltJsonObjectbuill.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueInteger) then;
                                end else begin
                                    Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                    if ltJsonObjectbuill.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueDecimal) then;
                                end;
                            end else
                                if ltJsonObjectbuill.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), format(ltFieldRef.Value)) then;
                        end;
                    end;
                until PageControl.Next() = 0;
            end;
            ltRecordRef.Close();

            CLEAR(ltJsonArray);
            CLEAR(ltFieldRef);
            CLEAR(ltJsonObjectbuillReserve);
            ltRecordRef.Open(39);
            ltFieldRef := ltRecordRef.FieldIndex(1);
            ltFieldRef.SetRange(pDocumentType);
            ltFieldRef := ltRecordRef.FieldIndex(2);
            ltFieldRef.SetRange(documentNo);
            if ltRecordRef.FindFirst() then begin
                repeat
                    CLEAR(ltJsonObject);
                    PageControl.reset();
                    PageControl.SetCurrentKey(FieldNo);
                    PageControl.SetRange(PageNo, pPageNOSubform);
                    if PageControl.FindSet() then
                        repeat
                            if ltRecordRef.FieldExist(PageControl.FieldNo) then begin
                                ltField.GET(PageControl.TableNo, PageControl.FieldNo);
                                if (ltField.Class = ltField.Class::Normal) and (ltField.Type <> ltField.Type::BLOB) then begin
                                    ltFieldRef := ltRecordRef.Field(ltField."No.");
                                    if ltField.Type in [ltField.Type::Decimal, ltField.Type::Integer] then begin
                                        if ltField.Type = ltField.Type::Integer then begin
                                            Evaluate(ValueInteger, format(ltFieldRef.Value));
                                            if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueInteger) then;
                                        end else begin
                                            Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                            if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueDecimal) then;
                                        end;
                                    end else
                                        if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), format(ltFieldRef.Value)) then;
                                end;
                            end;
                        until PageControl.Next() = 0;
                    CLEAR(ltJsonObjectReserve);
                    ltFieldRef := ltRecordRef.FieldIndex(3);
                    Evaluate(ltLineNo, ltFieldRef.Value);
                    ReservationEntry.reset();
                    ReservationEntry.SetRange("Source ID", documentNo);
                    ReservationEntry.SetRange("Source Ref. No.", ltLineNo);
                    if ReservationEntry.FindSet() then begin
                        repeat
                            ltJsonObjectReserve.Add('qty', 1);
                        until ReservationEntry.Next() = 0;
                        ltJsonObjectbuillReserve.Add('reservelines', ltJsonObjectReserve);
                    end;
                    ltJsonArray.Add(ltJsonObject);

                until ltRecordRef.next = 0;


                ltRecordRef.Close();
            end;
        end;
        ltJsonObjectbuill.Add('detail', ltJsonArray);
        ltJsonArraybuill.Add(ltJsonObjectbuill);

        ltResult.Add(pApiName, ltJsonArraybuill);
        ltResult.WriteTo(ltText);
        ltText := ltText.Replace('"', '\"');
        ltText := ltText.Replace('\"' + pApiName + '\":', '"' + pApiName + '":"');
        ltText := COPYSTR(ltText, 1, StrLen(ltText) - 1) + '"}';
        tempBlob.CreateOutStream(ltOutStr, TextEncoding::UTF8);
        ltOutStr.WriteText(ltText);
        tempBlob.CreateInStream(ltInstr, TextEncoding::UTF8);
        ltFileName := 'API_' + pApiName + '.txt';
        DownloadFromStream(ltInstr, 'Export', '', '', ltFileName)

    end;

    procedure ExportJsonFormat(pPageNO: Integer; pTableID: Integer; pApiName: Text)
    var
        PageControl: Record "Page Control Field";
        ltField: Record Field;
        ltJsonObject, ltResult : JsonObject;
        ltJsonArray: JsonArray;
        ltFieldRef: FieldRef;
        ltRecordRef: RecordRef;
        ltText: Text;
        tempBlob: Codeunit "Temp Blob";
        ltOutStr: OutStream;
        ltInstr: InStream;
        ltFileName: Text;
        ValueDecimal: Decimal;
        ValueInteger: Integer;
    begin

        ltRecordRef.Open(pTableID);
        if ltRecordRef.FindFirst() then begin
            CLEAR(ltJsonObject);
            CLEAR(ltJsonArray);
            PageControl.reset();
            PageControl.SetCurrentKey(FieldNo);
            PageControl.SetRange(PageNo, pPageNO);
            if PageControl.FindSet() then begin
                repeat
                    if ltRecordRef.FieldExist(PageControl.FieldNo) then begin
                        ltField.GET(PageControl.TableNo, PageControl.FieldNo);
                        if (ltField.Class = ltField.Class::Normal) and (ltField.Type <> ltField.Type::BLOB) then begin
                            ltFieldRef := ltRecordRef.Field(ltField."No.");
                            if ltField.Type in [ltField.Type::Decimal, ltField.Type::Integer] then begin
                                if ltField.Type = ltField.Type::Integer then begin
                                    Evaluate(ValueInteger, format(ltFieldRef.Value));
                                    if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueInteger) then;
                                end else begin
                                    Evaluate(ValueDecimal, format(ltFieldRef.Value));
                                    if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), ValueDecimal) then;
                                end;
                            end else
                                if ltJsonObject.Add(DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). '), format(ltFieldRef.Value)) then;
                        end;
                    end;
                until PageControl.Next() = 0;
                ltJsonArray.Add(ltJsonObject);
            end;
        end;
        ltResult.Add(pApiName, ltJsonArray);
        ltResult.WriteTo(ltText);
        ltText := ltText.Replace('"', '\"');
        ltText := ltText.Replace('\"' + pApiName + '\":', '"' + pApiName + '":"');
        ltText := COPYSTR(ltText, 1, StrLen(ltText) - 1) + '"}';
        tempBlob.CreateOutStream(ltOutStr, TextEncoding::UTF8);
        ltOutStr.WriteText(ltText);
        tempBlob.CreateInStream(ltInstr, TextEncoding::UTF8);
        ltFileName := 'API_' + pApiName + '.txt';
        DownloadFromStream(ltInstr, 'Export', '', '', ltFileName)
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
