#
# spec file for package suse-xsl-stylesheets
#
# Copyright (c) 2016 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           suse-xsl-stylesheets
Version:        2.0.6.3
Release:        0

###############################################################
#
#  IMPORTANT:
#  Only edit this file directly in the Git repo:
#  https://github.com/openSUSE/daps, branch develop,
#  packaging/suse-xsl-stylesheets.spec
#
#  Your changes will be lost on the next update.
#  If you do not have access to the Git repository, notify
#  <fsundermeyer@opensuse.org> and <toms@opensuse.org>
#  or send a patch.
#
################################################################

%define susexsl_catalog   catalog-for-%{name}.xml
%define db_xml_dir        %{_datadir}/xml/docbook
%define suse_styles_dir   %{db_xml_dir}/stylesheet

Summary:        SUSE-Branded Stylesheets for DocBook
License:        GPL-2.0 or GPL-3.0
Group:          Productivity/Publishing/XML
Url:            http://sourceforge.net/p/daps/suse-xslt
Source0:        %{name}-%{version}.tar.bz2
Source1:        susexsl-fetch-source-git
Source2:        %{name}.rpmlintrc
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildArch:      noarch

BuildRequires:  aspell
BuildRequires:  aspell-en
BuildRequires:  docbook-xsl-stylesheets >= 1.77
BuildRequires:  docbook5-xsl-stylesheets >= 1.77
BuildRequires:  fdupes
BuildRequires:  libxml2-tools
BuildRequires:  libxslt
BuildRequires:  make
# Only needed to fix the "have choice" error between xerces-j2 and crimson
%if 0%{?suse_version} == 1210
BuildRequires:  xerces-j2
%endif
BuildRequires:  fontpackages-devel
BuildRequires:  trang

Requires:       docbook_4
Requires:       docbook_5
Requires:       docbook-xsl-stylesheets >= 1.77
Requires:       docbook5-xsl-stylesheets >= 1.77
Requires:       libxslt
Requires:       aspell-en

Recommends:     daps


#------
# Fonts
#------

# Western fallback: currently necessary for building with XEP, it seems.
Requires:       ghostscript-fonts-std
# Western fallback 2: These should make the Ghostscript fonts unnecessary.
Requires:       gnu-free-fonts
# "Generic" font for use in cases where we don't want one of the gnu-free-fonts
Requires:       dejavu-fonts

# FONTS USED IN "suse" (aka "suse2005") STYLESHEETS
# Proprietary Western:
Recommends:     agfa-fonts
# Fallback for proprietary Western:
Requires:       liberation-fonts
# Japanese:
Requires:       sazanami-fonts
# Korean:
Requires:       un-fonts
# Chinese:
Requires:       wqy-microhei-fonts

# FONTS USED IN "suse2013" STYLESHEETS
# Western fonts:
Requires:       google-opensans-fonts
Requires:       sil-charis-fonts
# Monospace -- dejavu-fonts, already required
# Western fonts fallback -- gnu-free-fonts, already required
# Chinese simplified -- wqy-microhei-fonts, already required
# Chinese traditional:
Requires:       arphic-uming-fonts
# Japanese:
Requires:       ipa-pgothic-fonts
Requires:       ipa-pmincho-fonts
# Korean -- un-fonts, already required
# Arabic:
Requires:       arabic-amiri-fonts


%description
These are SUSE-branded XSLT 1.0 stylesheets for DocBook 4 and 5 that are be used
to create the HTML, PDF, and EPUB versions of SUSE documentation. These
stylesheets are based on the original DocBook XSLT 1.0 stylesheets.

This package also provides descriptions of two XML formats which authors can
use: The NovDoc DTD, a subset of the DocBook 4 DTD and the SUSEdoc schema, a
subset of the DocBook 5 schema.

#--------------------------------------------------------------------------

%prep
%setup -q -n %{name}

#--------------------------------------------------------------------------

%build
%__make  %{?_smp_mflags}

#--------------------------------------------------------------------------

%install
make install DESTDIR=%{buildroot}  LIBDIR=%{_libdir}

# create symlinks:
%fdupes -s %{buildroot}/%{_datadir}

#----------------------

%post
# XML Catalogs
#
# remove existing entries first - needed for
# zypper in, since it does not call postun
# delete ...
if [ "2" = "$1" ]; then
  edit-xml-catalog --group --catalog %{_sysconfdir}/xml/suse-catalog.xml \
    --del %{name} || true
fi

# ... and (re)add it again
edit-xml-catalog --group --catalog %{_sysconfdir}/xml/suse-catalog.xml \
  --add %{_sysconfdir}/xml/%{susexsl_catalog}
%reconfigure_fonts_post
exit 0

#----------------------

%postun
if [ "0" = "$1" ]; then
  %reconfigure_fonts_post
  edit-xml-catalog --group --catalog %{_sysconfdir}/xml/suse-catalog.xml \
    --del %{name} || true
fi

exit 0

#----------------------

%posttrans
%reconfigure_fonts_posttrans

#----------------------

%files
%defattr(-,root,root)

# Directories
%dir %{_datadir}/suse-xsl-stylesheets
%dir %{_datadir}/suse-xsl-stylesheets/aspell

%dir %{suse_styles_dir}
%dir %{suse_styles_dir}/suse
%dir %{suse_styles_dir}/suse-ns
%dir %{suse_styles_dir}/suse2013
%dir %{suse_styles_dir}/suse2013-ns
%dir %{suse_styles_dir}/daps2013
%dir %{suse_styles_dir}/daps2013-ns
%dir %{suse_styles_dir}/opensuse2013
%dir %{suse_styles_dir}/opensuse2013-ns

%dir %{_ttfontsdir}

%dir %{_defaultdocdir}/%{name}

# stylesheets
%{suse_styles_dir}/suse/*
%{suse_styles_dir}/suse-ns/*
%{suse_styles_dir}/suse2013/*
%{suse_styles_dir}/suse2013-ns/*
%{suse_styles_dir}/daps2013/*
%{suse_styles_dir}/daps2013-ns/*
%{suse_styles_dir}/opensuse2013/*
%{suse_styles_dir}/opensuse2013-ns/*

# Catalogs
%config %{_sysconfdir}/xml/*.xml

# Fonts
%{_ttfontsdir}/*

# Documentation
%doc %{_defaultdocdir}/%{name}/*

# SUSE aspell dictionary
%{_datadir}/suse-xsl-stylesheets/aspell/en_US-suse-addendum.rws

#----------------------

%changelog
