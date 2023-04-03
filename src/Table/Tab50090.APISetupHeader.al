/// <summary>
/// Table API Setup Header (ID 50090).
/// </summary>
table 50090 "API Setup Header"
{
    Caption = 'API Setup Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Page Name"; Option)
        {
            Caption = 'Page Name';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Item,Customer,Vendor,Purchase Order,Purchase Return Order,Good Receipt Note,Purchase Return Receipt,Sales Invoice,Sales Credit Memo,Item Journal,Item Reclass,Cash Receipt';
            OptionMembers = " ",Item,Customer,Vendor,"Purchase Order","Purchase Return Order","Good Receipt Note","Purchase Return Receipt","Sales Invoice","Sales Credit Memo","Item Journal","Item Reclass","Cash Receipt";
            trigger OnValidate()
            begin
                if rec."Page Name" <> xrec."Page Name" then begin
                    case "Page Name" of
                        1:
                            begin
                                rec."Page No." := page::"Item Card";
                                rec."Table ID" := Database::Item;
                                rec."Sub Page No." := 0;
                                rec."Sub Table ID" := 0;
                                rec."Serivce Name" := 'itemlists';
                            end;
                        2:
                            begin
                                rec."Page No." := page::"Customer Card";
                                rec."Table ID" := Database::Customer;
                                rec."Sub Page No." := 0;
                                rec."Sub Table ID" := 0;
                                rec."Serivce Name" := 'customerlists';
                            end;
                        3:
                            begin
                                rec."Page No." := page::"Vendor Card";
                                rec."Table ID" := Database::Vendor;
                                rec."Sub Page No." := 0;
                                rec."Sub Table ID" := 0;
                                rec."Serivce Name" := 'vendorlists';
                            end;
                        4:
                            begin
                                rec."Page No." := page::"Purchase Order";
                                rec."Sub Page No." := page::"Purchase Order Subform";
                                rec."Table ID" := Database::"Purchase Header";
                                rec."Sub Table ID" := Database::"Purchase Line";
                                rec."Serivce Name" := 'purchaseorderlists';
                            end;

                        5:
                            begin
                                rec."Page No." := page::"Purchase Order";
                                rec."Sub Page No." := 0;
                                rec."Table ID" := Database::"Purchase Line";
                                rec."Sub Table ID" := 0;
                                rec."Serivce Name" := 'goodreceiptnotelists';
                            end;

                        6:
                            begin
                                rec."Page No." := page::"Purchase Return Order";
                                rec."Sub Page No." := 0;
                                rec."Table ID" := Database::"Purchase Line";
                                rec."Sub Table ID" := 0;
                                rec."Serivce Name" := 'returnreceiptlists';
                            end;

                        7:
                            begin
                                rec."Page No." := page::"Purchase Return Order";
                                rec."Sub Page No." := page::"Purchase Return Order Subform";
                                rec."Table ID" := Database::"Purchase Header";
                                rec."Sub Table ID" := Database::"Purchase Line";
                                rec."Serivce Name" := 'purchasereturnorderlists';
                            end;

                        8:
                            begin
                                rec."Page No." := page::"Sales Invoice";
                                rec."Sub Page No." := page::"Sales Invoice Subform";
                                rec."Table ID" := Database::"Sales Header";
                                rec."Sub Table ID" := Database::"Sales Line";
                                rec."Serivce Name" := 'salesinvoicelists';
                            end;
                        9:
                            begin
                                rec."Page No." := page::"Sales Credit Memo";
                                rec."Sub Page No." := page::"Sales Cr. Memo Subform";
                                rec."Table ID" := Database::"Sales Header";
                                rec."Sub Table ID" := Database::"Sales Line";
                                rec."Serivce Name" := 'salescreditmemolists';
                            end;
                        10:
                            begin
                                rec."Page No." := page::"Item Journal";
                                rec."Sub Page No." := 0;
                                rec."Table ID" := Database::"Item Journal Line";
                                rec."Sub Table ID" := 0;
                                rec."Serivce Name" := 'itemjournal';
                            end;
                        11:
                            begin
                                rec."Page No." := page::"Item Reclass. Journal";
                                rec."Sub Page No." := 0;
                                rec."Table ID" := Database::"Item Journal Line";
                                rec."Sub Table ID" := 0;
                                rec."Serivce Name" := 'itemreclass';
                            end;
                        12:
                            begin
                                rec."Page No." := page::"Cash Receipt Journal";
                                rec."Sub Page No." := 0;
                                rec."Table ID" := Database::"Gen. Journal Line";
                                rec."Sub Table ID" := 0;
                                rec."Serivce Name" := 'cashreceipt';
                            end;
                    end;
                end;
            end;
        }
        field(2; "Page No."; Integer)
        {
            Caption = 'Page No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; "Sub Page No."; Integer)
        {
            Caption = 'Sub Page No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "Sub Table ID"; Integer)
        {
            Caption = 'Sub Table ID';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(7; "Remark"; Text[100])
        {
            Caption = 'Remark';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Serivce Name"; Text[50])
        {
            Caption = 'Serivce Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Page Name")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        rec.TestField("Page Name");
    end;

    trigger OnDelete()
    var
        APISetupLine: Record "API Setup Line";
    begin
        APISetupLine.reset();
        APISetupLine.SetRange("Page Name", rec."Page Name");
        APISetupLine.DeleteAll();
    end;

    trigger OnRename()
    begin
        ERROR('Cannot Rename');
    end;
    /// <summary>
    /// GenerateDetail.
    /// </summary>
    procedure GenerateDetail()
    var
        APISetupLine: Record "API Setup Line";
        ltField: Record Field;
    begin
        if not confirm('Do you want generate detail') then
            exit;
        APISetupLine.reset();
        APISetupLine.SetRange("Page Name", rec."Page Name");
        APISetupLine.DeleteAll();
        Commit();

        ltField.reset();
        ltField.SetCurrentKey(TableNo, "No.");
        ltField.SetRange(TableNo, rec."Table ID");
        ltField.SetRange(Enabled, true);
        ltField.SetRange(Class, ltField.Class::Normal);
        ltField.SetRange(ObsoleteState, ltField.ObsoleteState::No);
        ltField.SetFilter(Type, '<>%1&<>%2&<>%3&<>%4&<>%5&<>%6', ltField.Type::BLOB, ltField.Type::GUID, ltField.Type::Media, ltField.Type::MediaSet, ltField.Type::BigInteger, ltField.Type::Binary);
        if ltField.FindSet() then
            repeat
                APISetupLine.Init();
                APISetupLine."Page Name" := rec."Page Name";
                APISetupLine."Line Type" := APISetupLine."Line Type"::Header;
                APISetupLine."Field No." := ltField."No.";
                APISetupLine."Field Name" := ltField.FieldName;
                if ltField.Type in [ltField.Type::Code, ltField.Type::Text] then
                    APISetupLine.Lenth := format(ltField.Len);
                APISetupLine."Is Primary" := ltField.IsPartOfPrimaryKey;
                APISetupLine."Field Type" := format(ltField.Type);
                if ltField.Type in [ltField.Type::Option] then
                    APISetupLine.remark := ltField.OptionString;
                if ltField.Type in [ltField.Type::Boolean] then
                    APISetupLine.remark := 'Yes,No';
                if ltField.Type in [ltField.Type::Date] then
                    APISetupLine.remark := 'dd/mm/yyyy';
                APISetupLine."Is Primary" := ltField.IsPartOfPrimaryKey;
                APISetupLine."Field Type" := format(ltField.Type);
                APISetupLine.remark := ltField.OptionString;
                APISetupLine.Include := true;
                APISetupLine."Service Name" := DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). ');
                APISetupLine.Insert();
            until ltField.Next() = 0;

        if rec."Sub Table ID" <> 0 then begin
            ltField.reset();
            ltField.SetCurrentKey(TableNo, "No.");
            ltField.SetRange(TableNo, rec."Sub Table ID");
            ltField.SetRange(Enabled, true);
            ltField.SetRange(Class, ltField.Class::Normal);
            ltField.SetRange(ObsoleteState, ltField.ObsoleteState::No);
            ltField.SetFilter(Type, '<>%1&<>%2&<>%3&<>%4&<>%5&<>%6', ltField.Type::BLOB, ltField.Type::GUID, ltField.Type::Media, ltField.Type::MediaSet, ltField.Type::BigInteger, ltField.Type::Binary);
            if ltField.FindSet() then
                repeat
                    APISetupLine.Init();
                    APISetupLine."Page Name" := rec."Page Name";
                    APISetupLine."Line Type" := APISetupLine."Line Type"::Line;
                    APISetupLine."Field No." := ltField."No.";
                    APISetupLine."Field Name" := ltField.FieldName;
                    if ltField.Type in [ltField.Type::Code, ltField.Type::Text] then
                        APISetupLine.Lenth := format(ltField.Len);
                    APISetupLine."Is Primary" := ltField.IsPartOfPrimaryKey;
                    APISetupLine."Field Type" := format(ltField.Type);
                    if ltField.Type in [ltField.Type::Option] then
                        APISetupLine.remark := ltField.OptionString;
                    if ltField.Type in [ltField.Type::Boolean] then
                        APISetupLine.remark := 'Yes,No';
                    if ltField.Type in [ltField.Type::Date] then
                        APISetupLine.remark := 'dd/mm/yyyy';
                    APISetupLine.Include := true;
                    APISetupLine."Service Name" := DelChr(LowerCase(ltField.FieldName), '=', '_-&%(). ');
                    APISetupLine.Insert();
                until ltField.Next() = 0;
        end;
    end;
}
