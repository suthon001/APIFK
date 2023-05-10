/// <summary>
/// Table API Setup Header (ID 60050).
/// </summary>
table 60050 "API Setup Header"
{
    Caption = 'API Setup Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Page Name"; Enum "FK Api Page Type")
        {
            Caption = 'Page Name';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if rec."Page Name" <> xrec."Page Name" then begin
                    case "Page Name" of
                        "Page Name"::Item:
                            begin
                                rec."Page No." := page::"Item Card";
                                rec."Table ID" := Database::Item;
                                rec."Sub Page No." := 0;
                                rec."Sub Table ID" := 0;
                                rec."Serivce Name" := 'itemlists';
                            end;
                        "Page Name"::Customer:
                            begin
                                rec."Page No." := page::"Customer Card";
                                rec."Table ID" := Database::Customer;
                                rec."Sub Page No." := Page::"Ship-to Address";
                                rec."Sub Table ID" := Database::"Ship-to Address";
                                rec."Serivce Name" := 'customerlists';
                            end;
                        "Page Name"::Vendor:
                            begin
                                rec."Page No." := page::"Vendor Card";
                                rec."Table ID" := Database::Vendor;
                                rec."Sub Page No." := 0;
                                rec."Sub Table ID" := 0;
                                rec."Serivce Name" := 'vendorlists';
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
        field(9; "URL"; Text[2047])
        {
            Caption = 'URL';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                rec.TestField("Page Name", rec."Page Name"::Vendor);
            end;
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
    /// apisetuplineexists.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure apisetuplineexists(): Boolean
    var
        apisetupline: Record "API Setup Line";
    begin
        apisetupline.Reset();
        apisetupline.SetRange("Page Name", rec."Page Name");
        exit(apisetupline.IsEmpty);
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
        ltField.SetFilter(FieldName, '<>%1', 'NWTH*');
        ltField.SetFilter("No.", '<>%1&<>%2', 2000000001, 2000000003);
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
                APISetupLine."Service Name" := DelChr(LowerCase(ltField.FieldName), '=', '_-&%()/\. ');
                APISetupLine.Insert();
            until ltField.Next() = 0;

        if rec."Sub Table ID" <> 0 then begin
            ltField.reset();
            ltField.SetCurrentKey(TableNo, "No.");
            ltField.SetRange(TableNo, rec."Sub Table ID");
            ltField.SetRange(Enabled, true);
            ltField.SetRange(Class, ltField.Class::Normal);
            ltField.SetFilter(FieldName, '<>%1', 'NWTH*');
            ltField.SetFilter("No.", '<>%1&<>%2', 2000000001, 2000000003);
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
                    APISetupLine."Service Name" := DelChr(LowerCase(ltField.FieldName), '=', '_-&%()/\. ');
                    APISetupLine.Insert();
                until ltField.Next() = 0;
        end;
    end;
}
