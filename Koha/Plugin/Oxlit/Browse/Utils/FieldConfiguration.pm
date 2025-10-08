package Koha::Plugin::Oxlit::Browse::Utils::FieldConfiguration;

use strict;
use warnings;
use Koha::Plugin::Oxlit::Browse::Utils::Constants qw(DISPLAY_BRIEF DISPLAY_FULL DISPLAY_BOTH);

use Exporter qw(import);
our @EXPORT_OK = qw(getFieldConfiguration);

sub getFieldConfiguration {
    my $field_config = {
        '020' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                isbn => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '022' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                issn => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '041' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                language => {'code' => 'a', repeatable => 1, display => DISPLAY_FULL}, 
                original_language => {'code' => 'h', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '090' => {
            repeatable => 0,
            display => DISPLAY_BOTH,
            subfields => [
                control_number => {'code' => 'c', repeatable => 0, display => DISPLAY_BOTH}
            ]
        },
        '100' => { 
            repeatable => 0,
            display => DISPLAY_BOTH,
            subfields => [
                author => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                author_dates => {'code' => 'd', repeatable => 0, display => DISPLAY_BOTH}, 
                author_role => {'code' => 'e', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '110' => {
            repeatable => 0,
            display => DISPLAY_FULL,
            subfields => [
                corporate_name => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL},
                corporate_sub_unit => {'code' => 'b', repeatable => 1, display => DISPLAY_FULL},
                corporate_location => {'code' => 'c', repeatable => 1, display => DISPLAY_FULL},
                corporate_date => {'code' => 'd', repeatable => 1, display => DISPLAY_FULL}
            ]
        },
        '111' => {
            repeatable => 0,
            display => DISPLAY_FULL,
            subfields => [
                meeting_name => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}, 
                meeting_location => {'code' => 'c', repeatable => 1, display => DISPLAY_FULL}, 
                meeting_dates => {'code' => 'd', repeatable => 1, display => DISPLAY_FULL}, 
                meeting_section_number => {'code' => 'n', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '240' => { 
            repeatable => 0,
            display => DISPLAY_FULL,
            subfields => [
                uniform_title => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}, 
                uniform_title_language => {'code' => 'l', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '245' => { 
            repeatable => 0,
            display => DISPLAY_BOTH,
            subfields => [
                title => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                title_remainder => {'code' => 'b', repeatable => 0, display => DISPLAY_BOTH}, 
                statement_of_responsibility => {'code' => 'c', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '246' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                title_proper => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                title_proper_remainder => {'code' => 'b', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '250' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                edition_statement => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '260' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                publication_location => {'code' => 'a', repeatable => 1, display => DISPLAY_BOTH}, 
                publisher => {'code' => 'b', repeatable => 1, display => DISPLAY_BOTH}, 
                publication_date => {'code' => 'c', repeatable => 1, display => DISPLAY_BOTH}
            ] 
        },
        '300' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                extent => {'code' => 'a', repeatable => 1, display => DISPLAY_BOTH}, 
                other_physical_details => {'code' => 'b', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '440' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                series_title => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                series_volume_number => {'code' => 'v', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '500' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                notes => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '504' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                bibliographical_note => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '505' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                contents => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '520' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                summary => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '546' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                language_note => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '600' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                author_as_subject => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                author_as_subject_dates => {'code' => 'd', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '650' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                subject => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                subject_dates => {'code' => 'd', repeatable => 0, display => DISPLAY_FULL}, 
                subject_form_subdivision => {'code' => 'v', repeatable => 1, display => DISPLAY_FULL}, 
                subject_general_subdivision => {'code' => 'x', repeatable => 1, display => DISPLAY_BOTH}, 
                subject_chron_subdivision => {'code' => 'y', repeatable => 1, display => DISPLAY_FULL}, 
                subject_geo_subdivision => {'code' => 'z', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '700' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                added_author => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}, 
                added_author_dates => {'code' => 'd', repeatable => 0, display => DISPLAY_BOTH},
                added_author_role => {'code' => 'e', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '710' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                added_corporate_name => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}, 
                added_corporate_sub_unit => {'code' => 'b', repeatable => 1, display => DISPLAY_FULL}, 
                added_corporate_location => {'code' => 'c', repeatable => 1, display => DISPLAY_FULL}, 
                added_corporate_date => {'code' => 'd', repeatable => 1, display => DISPLAY_FULL}, 
                added_corporate_section_number => {'code' => 'n', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '711' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                added_meeting_name => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}, 
                added_meeting_location => {'code' => 'c', repeatable => 1, display => DISPLAY_FULL}, 
                added_meeting_dates => {'code' => 'd', repeatable => 1, display => DISPLAY_FULL}, 
                added_meeting_section_number => {'code' => 'n', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '773' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                host_item_relationship => {'code' => 'g', repeatable => 1, display => DISPLAY_BOTH},
                host_item_title => {'code' => 't', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '774' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                constituent_titles => {'code' => 't', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '856' => { 
            repeatable => 1,
            display => DISPLAY_BOTH,
            subfields => [
                uri_host_name => {'code' => 'a', repeatable => 1, display => DISPLAY_FULL},
                uri => {'code' => 'u', repeatable => 1, display => DISPLAY_BOTH},
                uri_control_number => {'code' => 'w', repeatable => 1, display => DISPLAY_FULL}, 
                uri_link_text => {'code' => 'y', repeatable => 1, display => DISPLAY_FULL}, 
                uri_public_note => {'code' => 'z', repeatable => 1, display => DISPLAY_FULL}
            ] 
        },
        '911' => { 
            repeatable => 0,
            display => DISPLAY_BOTH,
            subfields => [
                document_type => {'code' => 'a', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        },
        '912' => { 
            repeatable => 1,
            display => DISPLAY_FULL,
            subfields => [
                source_type => {'code' => 'a', repeatable => 0, display => DISPLAY_FULL}
            ] 
        },
        '999' => { 
            repeatable => 0,
            display => DISPLAY_BOTH,
            subfields => [
                biblio_number => {'code' => 'c', repeatable => 0, display => DISPLAY_BOTH}
            ] 
        }
    };

    return $field_config;
}

1;